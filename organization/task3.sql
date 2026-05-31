-- Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0).
-- Для каждого такого сотрудника вывести следующую информацию:

-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH RECURSIVE AllSubs AS (
    SELECT e.EmployeeID AS ManagerID, e.EmployeeID AS SubID
    FROM Employees e
    UNION ALL
    SELECT a.ManagerID, e.EmployeeID
    FROM Employees e
    JOIN AllSubs a ON e.ManagerID = a.SubID
),
ManagerSubCount AS (
    SELECT ManagerID, COUNT(*) - 1 AS TotalSubordinates
    FROM AllSubs
    GROUP BY ManagerID
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT ARRAY_TO_STRING(ARRAY_AGG(DISTINCT p.ProjectName ORDER BY p.ProjectName), ', ')
     FROM Projects p
     WHERE p.DepartmentID = e.DepartmentID) AS ProjectNames,
    (SELECT ARRAY_TO_STRING(ARRAY_AGG(DISTINCT t.TaskName ORDER BY t.TaskName), ', ')
     FROM Tasks t
     WHERE t.AssignedTo = e.EmployeeID) AS TaskNames,
    msc.TotalSubordinates
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
JOIN ManagerSubCount msc ON e.EmployeeID = msc.ManagerID
WHERE r.RoleName = 'Менеджер' AND msc.TotalSubordinates > 0
ORDER BY e.Name;