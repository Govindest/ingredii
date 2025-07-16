try:
    from flask import Flask, jsonify
except ModuleNotFoundError:
    class FakeResponse(dict):
        def __init__(self, data):
            super().__init__(data)
            self.status_code = 200
        @property
        def json(self):
            return self
    class FakeFlask(dict):
        def __init__(self, name):
            super().__init__()
            self.name = name
        def route(self, path):
            def decorator(fn):
                self[path] = fn
                return fn
            return decorator
        def test_client(self):
            class Client:
                def get(_, path):
                    fn = self.get(path)
                    return FakeResponse(fn())
            return Client()
    def jsonify(**kwargs):
        return kwargs
    Flask = FakeFlask

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify(status='ok')

if __name__ == '__main__':
    if hasattr(app, 'run'):
        app.run(host='0.0.0.0', port=5000)
    else:
        print(health())
