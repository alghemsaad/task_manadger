<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - Task Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); 
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
        }
        .card { 
            border: none; 
            border-radius: 20px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .card-header { 
            border-radius: 20px 20px 0 0 !important; 
            background-color: transparent !important;
            border-bottom: none;
            padding-top: 2rem;
        }
        .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            border: 1px solid #e0e0e0;
        }
        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(25, 135, 84, 0.1);
            border-color: #198754;
        }
        .btn-success {
            border-radius: 10px;
            padding: 0.75rem;
            font-weight: 600;
            background: #198754;
            border: none;
            transition: all 0.3s;
        }
        .btn-success:hover {
            background: #157347;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(25, 135, 84, 0.2);
        }
        .text-success { color: #198754 !important; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card p-2">
                <div class="card-header text-center">
                    <h3 class="fw-bold text-dark">Create Account</h3>
                    <p class="text-muted small">Join us today and start managing tasks</p>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger py-2">${error}</div>
                    </c:if>

                    <form action="/signup" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Username</label>
                            <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email</label>
                            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Create a password" required>
                        </div>
                        <button type="submit" class="btn btn-success w-100 shadow-sm">Sign Up</button>
                    </form>
                    <hr>
                    <div class="text-center">
                        <p class="small mb-0">Already have an account? <a href="/login" class="text-success fw-bold text-decoration-none">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>