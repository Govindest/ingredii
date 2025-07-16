class InMemoryDB:
    def __init__(self):
        self._items = [
            {"name": "milk", "expiry_days": 7},
            {"name": "bread", "expiry_days": 3},
        ]

    def get_items(self):
        return self._items
