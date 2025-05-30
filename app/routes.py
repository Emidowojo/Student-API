import logging
from flask import request, jsonify
from .models import db, Student

logger = logging.getLogger(__name__)

def init_routes(app):
    @app.route('/')
    def home():
        return "Hello, World!"
    @app.route('/api/v1/healthcheck', methods=['GET'])
    def healthcheck():
        return jsonify({"status": "healthy"}), 200

    @app.route('/api/v1/students', methods=['POST'])
    def add_student():
        data = request.get_json()
        student = Student(name=data['name'], age=data['age'])
        db.session.add(student)
        db.session.commit()
        logger.info(f"Student {student.name} added with ID {student.id}")
        return jsonify(student.to_dict()), 201

    @app.route('/api/v1/students', methods=['GET'])
    def get_students():
        students = Student.query.all()
        return jsonify([s.to_dict() for s in students]), 200

    @app.route('/api/v1/students/<int:id>', methods=['GET'])
    def get_student(id):
        student = Student.query.get_or_404(id)
        return jsonify(student.to_dict()), 200

    @app.route('/api/v1/students/<int:id>', methods=['PUT'])
    def update_student(id):
        student = Student.query.get_or_404(id)
        data = request.get_json()
        student.name = data.get('name', student.name)
        student.age = data.get('age', student.age)
        db.session.commit()
        return jsonify(student.to_dict()), 200

    @app.route('/api/v1/students/<int:id>', methods=['DELETE'])
    def delete_student(id):
        student = Student.query.get_or_404(id)
        db.session.delete(student)
        db.session.commit()
        return '', 204