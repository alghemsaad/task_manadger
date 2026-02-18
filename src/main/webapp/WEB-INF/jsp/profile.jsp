<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile - Task Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8fafc; font-family: 'Inter', sans-serif; color: #1e293b; }
        .navbar { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(10px); border-bottom: 1px solid #e2e8f0; padding: 1rem 0; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .form-control { border-radius: 8px; border: 1px solid #e2e8f0; padding: 0.6rem 1rem; }
        .form-control:focus { box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1); border-color: #3b82f6; }
        .btn-action { border-radius: 8px; font-weight: 600; padding: 0.6rem 1.5rem; transition: all 0.2s; }
        .profile-avatar { width: 80px; height: 80px; background-color: #3b82f6; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: bold; margin-bottom: 1rem; }
    </style>
</head>
<body>

<nav class="navbar sticky-top mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary d-flex align-items-center" href="/tasks">
            <i class="bi bi-check2-circle fs-3 me-2"></i>
            <span>TaskMaster</span>
        </a>
        <div class="ms-auto d-flex align-items-center">
            <a href="/tasks" class="btn btn-link text-decoration-none me-3">Back to Tasks</a>
            <a href="/logout" class="btn btn-outline-danger btn-sm px-3 fw-bold rounded-pill">Logout</a>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card p-4">
                <div class="text-center mb-4">
                    <div class="d-inline-flex profile-avatar mx-auto">
                        ${sessionScope.loggedInUser.username.substring(0, 1).toUpperCase()}
                    </div>
                    <h3 class="fw-bold">Your Profile</h3>
                    <p class="text-muted">Manage your account information</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="/profile/update" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Username</label>
                        <input type="text" name="username" class="form-control" value="${sessionScope.loggedInUser.username}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Email</label>
                        <input type="email" name="email" class="form-control" value="${sessionScope.loggedInUser.email}">
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase">New Password (leave blank to keep current)</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••">
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-action">Update Profile</button>
                    </div>
                </form>

                <hr class="my-4">

                <div class="bg-danger bg-opacity-10 p-4 rounded-3">
                    <h5 class="text-danger fw-bold mb-2">Danger Zone</h5>
                    <p class="small text-muted mb-3">Once you delete your account, there is no going back. Please be certain.</p>
                    <form action="/profile/delete" method="post" onsubmit="return confirm('Are you sure you want to delete your account? This action cannot be undone.')">
                        <button type="submit" class="btn btn-outline-danger btn-sm fw-bold">Delete My Account</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
