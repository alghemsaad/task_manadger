<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Friends - Task Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8fafc; font-family: 'Inter', sans-serif; color: #1e293b; }
        .navbar { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(10px); border-bottom: 1px solid #e2e8f0; padding: 1rem 0; }
        .card { border: none; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .btn-action { padding: 0.4rem 0.8rem; border-radius: 8px; font-weight: 500; }
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
            <div class="me-3 d-none d-md-block text-end">
                <div class="small text-muted">Signed in as</div>
                <div class="fw-semibold"><a href="/profile" class="text-decoration-none">${sessionScope.loggedInUser.username}</a></div>
            </div>
            <a href="/logout" class="btn btn-outline-danger btn-sm px-3 fw-bold rounded-pill me-3">Logout</a>
            <a href="/tasks" class="btn btn-outline-primary btn-sm px-3 fw-bold rounded-pill">Back to Dashboard</a>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="row">
        <!-- Send Request -->
        <div class="col-md-4">
            <div class="card p-4 mb-4">
                <h5 class="fw-bold mb-3">Add Friend</h5>
                <form action="/friends/request" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Username</label>
                        <input type="text" name="username" class="form-control" placeholder="Search by username..." required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Send Request</button>
                </form>
                <c:if test="${param.error == 'user_not_found'}">
                    <div class="alert alert-danger mt-3 small">User not found.</div>
                </c:if>
                <c:if test="${param.error == 'already_sent'}">
                    <div class="alert alert-warning mt-3 small">Request already sent or users already friends.</div>
                </c:if>
                <c:if test="${param.success == 'request_sent'}">
                    <div class="alert alert-success mt-3 small">Friend request sent!</div>
                </c:if>
            </div>
        </div>

        <!-- Pending Requests -->
        <div class="col-md-8">
            <div class="card p-4 mb-4">
                <h5 class="fw-bold mb-3">Pending Requests</h5>
                <div class="list-group list-group-flush">
                    <c:forEach var="req" items="${pendingRequests}">
                        <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                            <div>
                                <span class="fw-bold">${req.sender.username}</span>
                                <span class="text-muted small d-block">${req.sender.email}</span>
                            </div>
                            <div class="d-flex gap-2">
                                <form action="/friends/accept" method="post">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <button type="submit" class="btn btn-sm btn-success btn-action">Accept</button>
                                </form>
                                <form action="/friends/reject" method="post">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger btn-action">Reject</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty pendingRequests}">
                        <p class="text-muted mb-0">No pending requests.</p>
                    </c:if>
                </div>
            </div>

            <!-- Friends List -->
            <div class="card p-4">
                <h5 class="fw-bold mb-3">My Friends</h5>
                <div class="list-group list-group-flush">
                    <c:forEach var="friend" items="${friends}">
                        <div class="list-group-item d-flex align-items-center px-0">
                            <div class="bg-primary bg-opacity-10 p-2 rounded-circle me-3">
                                <i class="bi bi-person text-primary"></i>
                            </div>
                            <div>
                                <span class="fw-bold">${friend.username}</span>
                                <span class="text-muted small d-block">${friend.email}</span>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty friends}">
                        <p class="text-muted mb-0">You haven't added any friends yet.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
