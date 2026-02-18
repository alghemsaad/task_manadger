<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Task Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { background-color: #f8fafc; font-family: 'Inter', sans-serif; color: #1e293b; }
        .navbar { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(10px); border-bottom: 1px solid #e2e8f0; padding: 1rem 0; }
        .card { border: none; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .table-container { background: white; border-radius: 12px; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .task-row { border-bottom: 1px solid #f1f5f9; transition: background 0.2s; }
        .task-row:hover { background-color: #f8fafc; }
        .status-pill { font-size: 0.75rem; padding: 6px 12px; border-radius: 6px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.025em; }
        .bg-done { background-color: #dcfce7; color: #166534; }
        .bg-progress { background-color: #fef9c3; color: #854d0e; }
        .bg-todo { background-color: #f1f5f9; color: #475569; }
        .badge-owner { background-color: #eff6ff; color: #1e40af; border: 1px solid #dbeafe; font-weight: 500; }
        .btn-action { padding: 0.4rem 0.8rem; border-radius: 8px; font-weight: 500; font-size: 0.875rem; transition: all 0.2s; }
        .form-control { border-radius: 8px; border: 1px solid #e2e8f0; padding: 0.6rem 1rem; }
        .form-control:focus { box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1); border-color: #3b82f6; }
        .add-task-card { background: linear-gradient(to right, #ffffff, #f8fafc); border: 1px solid #e2e8f0; }
    </style>
</head>
<body>

<nav class="navbar sticky-top mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary d-flex align-items-center" href="#">
            <i class="bi bi-check2-circle fs-3 me-2"></i>
            <span>TaskMaster</span>
        </a>
        <div class="ms-auto d-flex align-items-center">
            <div class="me-3 d-none d-md-block text-end">
                <div class="small text-muted">Signed in as</div>
                <div class="fw-semibold"><a href="/profile" class="text-decoration-none">${sessionScope.loggedInUser.username}</a></div>
            </div>
            <a href="/logout" class="btn btn-outline-danger btn-sm px-3 fw-bold rounded-pill">Logout</a>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="card add-task-card p-4 mb-5">
        <div class="d-flex align-items-center mb-3">
            <div class="bg-primary bg-opacity-10 p-2 rounded-3 me-3">
                <i class="bi bi-plus-lg text-primary fw-bold"></i>
            </div>
            <h5 class="fw-bold mb-0 text-dark">Create New Task</h5>
        </div>
        <form action="/tasks/add" method="post" class="row g-3">
            <input type="hidden" name="redirect" value="${viewMode == 'mine' ? '/my-tasks' : '/tasks'}">
            <div class="col-md-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Title</label>
                <input type="text" name="title" class="form-control" placeholder="What needs to be done?" required>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold text-muted text-uppercase">Description</label>
                <input type="text" name="description" class="form-control" placeholder="Add some details...">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100 fw-bold btn-action py-2">
                    <i class="bi bi-send-fill me-2"></i>Add Task
                </button>
            </div>
        </form>
    </div>

    <div class="table-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold mb-0">${viewMode == 'mine' ? 'My Personal Tasks' : 'Shared Tasks Dashboard'}</h4>
            <div class="d-flex gap-2">
                <a href="/friends" class="btn btn-outline-secondary btn-sm rounded-pill px-3">Manage Friends</a>
                <a href="/my-tasks" class="btn ${viewMode == 'mine' ? 'btn-primary' : 'btn-outline-primary'} btn-sm rounded-pill px-3">My Tasks</a>
                <a href="/tasks" class="btn ${viewMode == 'all' ? 'btn-primary' : 'btn-outline-primary'} btn-sm rounded-pill px-3">Shared Board</a>
                <span class="badge bg-secondary rounded-pill px-3 py-2">${tasks.size()} tasks</span>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr class="text-muted small text-uppercase">
                    <th class="ps-0" style="width: 40%">Task Details</th>
                    <th style="width: 20%">Owner</th>
                    <th style="width: 15%">Status</th>
                    <th class="text-end pe-0" style="width: 25%">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="task" items="${tasks}">
                    <tr class="task-row">
                        <td class="ps-0 py-3">
                            <div class="fw-bold text-dark fs-6">${task.title}</div>
                            <div class="text-muted small">${task.description}</div>
                        </td>
                        <td>
                            <span class="badge badge-owner px-3 py-2 rounded-pill">
                                <i class="bi bi-person me-1"></i> ${task.user.username}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${task.status == 'DONE'}">
                                    <span class="status-pill bg-done">Done</span>
                                </c:when>
                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                    <span class="status-pill bg-progress text-dark">In Progress</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill bg-todo">To Do</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end pe-0">
                            <c:if test="${task.user.id == sessionScope.loggedInUser.id}">
                                <div class="d-flex justify-content-end gap-2">
                                    <c:if test="${task.status != 'IN_PROGRESS' && task.status != 'DONE'}">
                                        <a href="/tasks/update?id=${task.id}&status=IN_PROGRESS&redirect=${viewMode == 'mine' ? '/my-tasks' : '/tasks'}" class="btn btn-sm btn-outline-warning btn-action" title="Start Task">
                                            <i class="bi bi-play-fill"></i>
                                        </a>
                                    </c:if>

                                    <c:if test="${task.status != 'DONE'}">
                                        <a href="/tasks/update?id=${task.id}&status=DONE&redirect=${viewMode == 'mine' ? '/my-tasks' : '/tasks'}" class="btn btn-sm btn-outline-success btn-action" title="Mark as Done">
                                            <i class="bi bi-check-lg"></i>
                                        </a>
                                    </c:if>

                                    <a href="/tasks/delete?id=${task.id}&redirect=${viewMode == 'mine' ? '/my-tasks' : '/tasks'}" class="btn btn-sm btn-outline-danger btn-action" onclick="return confirm('Are you sure?')" title="Delete Task">
                                        <i class="bi bi-trash3"></i>
                                    </a>
                                </div>
                            </c:if>

                            <c:if test="${task.user.id != sessionScope.loggedInUser.id}">
                                <span class="text-muted small fst-italic">
                                    <i class="bi bi-eye me-1"></i> View Only
                                </span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty tasks}">
                    <tr>
                        <td colspan="4" class="text-center py-5">
                            <i class="bi bi-clipboard2-check fs-1 text-muted opacity-25"></i>
                            <p class="text-muted mt-2">No tasks found. Time to add some!</p>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>