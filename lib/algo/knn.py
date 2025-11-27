import os
import os
import numpy as np
import math

DATASET_DIR = "/var/cache/yuno-watch/sum_nginx"
MAX_LEN = 256  # Max vector length


class Vectorizer:
    def to_vector(self, text):
        text_bytes = np.frombuffer(text.encode("utf-8", errors="replace"), dtype=np.uint8)
        length = len(text_bytes)

        # Pad/truncate byte vector
        byte_vec = np.zeros(MAX_LEN, dtype=np.float32)
        if length >= MAX_LEN:
            byte_vec[:] = text_bytes[:MAX_LEN]
        else:
            byte_vec[:length] = text_bytes

        text_arr = np.array(list(text))

        # specials
        specials_mask = np.array([not c.isalnum() for c in text_arr])
        count_special = specials_mask.sum()
        ratio_special = count_special / length if length > 0 else 0

        # digits
        digits_mask = np.array([c.isdigit() for c in text_arr])
        digit_count = digits_mask.sum()

        # uppercase
        uppercase_mask = np.array([c.isupper() for c in text_arr])
        uppercase_count = uppercase_mask.sum()

        # entropy
        if length > 0:
            unique, counts = np.unique(text_arr, return_counts=True)
            probs = counts / length
            entropy = -np.sum(probs * np.log2(probs))
        else:
            entropy = 0.0

        handcrafted = np.array([
            length, count_special, ratio_special, digit_count, uppercase_count, entropy
        ], dtype=np.float32)

        return np.concatenate([handcrafted, byte_vec])


class DatasetLoader:
    def __init__(self):
        self.valid200 = []
        self.valid404 = []
        self.invalid4xx = []

    def load_datasets(self, base):
        self.valid200 = self._load(os.path.join(base, "2xx.log"))
        self.valid404 = self._load(os.path.join(base, "valid_4xx.log"))
        self.invalid4xx = self._load(os.path.join(base, "critical_aggression.log"))

    def _load(self, path):
        if not os.path.exists(path):
            return []
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            return [line.strip() for line in f.readlines() if line.strip()]


class KNN:
    def __init__(self):
        self.X = None
        self.y = None

    def train(self, vectors, labels):
        self.X = np.array(vectors, dtype=np.float32)
        self.y = np.array(labels, dtype=np.int32)

    def predict(self, vector, k=8):
        distances = np.linalg.norm(self.X - vector, axis=1)

        idx = np.argsort(distances)[:k]
        nearest_labels = self.y[idx]

        values, counts = np.unique(nearest_labels, return_counts=True)
        majority_label = values[np.argmax(counts)]
        confidence = counts.max() / k

        return majority_label, confidence

    def estimate_accuracy(self, k=8):
        correct = 0
        total = len(self.X)

        for i in range(total):
            sample = self.X[i]
            true = self.y[i]

            distances = np.linalg.norm(self.X - sample, axis=1)
            distances[i] = np.inf  # ignore self

            idx = np.argsort(distances)[:k]
            nearest_labels = self.y[idx]

            # Adds counts to the label that is most similar
            counts = np.bincount(nearest_labels)
            pred = np.argmax(counts)

            correct += (pred == true)

        return correct / total 


def main():
    loader = DatasetLoader()
    loader.load_datasets(DATASET_DIR)

    vect = Vectorizer()

    X = []
    y = []
    for line in loader.valid200:
        X.append(vect.to_vector(line))
        y.append(0)

    for line in loader.valid404:
        X.append(vect.to_vector(line))
        y.append(0)

    for line in loader.invalid4xx:
        X.append(vect.to_vector(line))
        y.append(1)

    knn = KNN()
    knn.train(X, y)

    accuracy = knn.estimate_accuracy(k=8)
    print("Model accuracy: ", accuracy)

    while True:
        user_input = input("Enter a path (or type 'exit' to quit): ").strip()
        if user_input.lower() == "exit":
            print("Exiting....")
            break

        if user_input == "":
            print("Cannot be empty.")
            continue

        test_vec = vect.to_vector(user_input)

        label, confidence = knn.predict(test_vec, k=5)

        decision = "allow" if label == 0 else "block"

        print(f"Prediction: {decision}, Confidence: {confidence:.3f}")
        print()


if __name__ == "__main__":
    main()
