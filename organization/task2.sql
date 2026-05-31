-- Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных, 
-- а также самого Ивана Иванова. 
-- Для каждого сотрудника вывести следующую информацию:

-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество задач, назначенных этому сотруднику.
-- Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
-- Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.

WITH RECURSIVE IvanTree AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN IvanTree it ON e.ManagerID = it.EmployeeID
)
SELECT
    it.EmployeeID,
    it.Name AS EmployeeName,
    it.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT ARRAY_TO_STRING(ARRAY_AGG(DISTINCT p.ProjectName ORDER BY p.ProjectName), ', ')
     FROM Projects p
     WHERE p.DepartmentID = it.DepartmentID) AS ProjectNames,
    (SELECT ARRAY_TO_STRING(ARRAY_AGG(DISTINCT t.TaskName ORDER BY t.TaskName), ', ')
     FROM Tasks t
     WHERE t.AssignedTo = it.EmployeeID) AS TaskNames,
    (SELECT COUNT(*) FROM Tasks t WHERE t.AssignedTo = it.EmployeeID) AS TotalTasks,
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = it.EmployeeID) AS TotalSubordinates
FROM IvanTree it
JOIN Departments d ON it.DepartmentID = d.DepartmentID
JOIN Roles r ON it.RoleID = r.RoleID
ORDER BY it.Name;