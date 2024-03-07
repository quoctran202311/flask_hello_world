from flask_login import UserMixin

class User(UserMixin):
    def __init__(self, id, username):
        self.id = id
        self.username = username

    def __repr__(self):
        return f'<User: {self.username}>'

# Dummy users for testing
users = {
    1: User(1, 'user1'),
    2: User(2, 'user2'),
}
