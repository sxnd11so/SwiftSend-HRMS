-- ==============================
-- STEP 1: Drop and Recreate
-- ==============================
DROP TABLE IF EXISTS ExpiryAlerts;
DROP TABLE IF EXISTS LeaveRequests;
DROP TABLE IF EXISTS Documents;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Users;

CREATE DATABASE IF NOT EXISTS HRMS;
USE HRMS;

-- ==============================
-- STEP 2: Create Tables
-- ==============================
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('HR', 'Employee', 'Manager') NOT NULL
);

CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50),
    hire_date DATE,
    annual_leave_days INT DEFAULT 15,
    sick_leave_days INT DEFAULT 10,
    leave_days_used DECIMAL(5,2) DEFAULT 0,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    doc_type ENUM('Contract', 'ID', 'Licence', 'Certification') NOT NULL,
    file_path VARCHAR(255),
    issue_date DATE,
    expiry_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE LeaveRequests (
    leave_id INT AUTO_INCREMENT PRIMARY KEY, 
    employee_id INT NOT NULL,
    leave_type ENUM('Annual', 'Sick', 'Study', 'Unpaid') DEFAULT 'Annual',
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested DECIMAL(5,2) NOT NULL,
    reason VARCHAR(255),
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    approved_by INT,
    approval_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (approved_by) REFERENCES Users(user_id)
);

CREATE TABLE ExpiryAlerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT NOT NULL,
    alert_date DATE NOT NULL,
    status ENUM('Unread', 'Read') DEFAULT 'Unread',
    FOREIGN KEY (document_id) REFERENCES Documents(document_id)
);

-- ==============================
-- STEP 3: MUST Insert Users First
-- ==============================
INSERT INTO Users (username, password_hash, role) VALUES
('hr.admin', SHA2('HRAdmin2024!', 256), 'HR'),
('thandi.mokoena', SHA2('Thandi@123', 256), 'Employee'),
('sipho.ndlovu', SHA2('Sipho2024', 256), 'Employee'),
('lerato.dlamini', SHA2('Lerato#Manager', 256), 'Manager'),
('john.smith', SHA2('JohnS@2024', 256), 'Employee'),
('nomsa.khumalo', SHA2('Nomsa456!', 256), 'Employee'),
('mpho.mabasa', SHA2('Mpho#Driver1', 256), 'Employee'),
('zanele.nkosi', SHA2('Zanele@HR24', 256), 'HR'),
('david.van.der.merwe', SHA2('David2024!', 256), 'Employee'),
('fatima.abrahams', SHA2('Fatima@Swift', 256), 'Employee'),
('peter.molefe', SHA2('PeterFleet99', 256), 'Manager'),
('sarah.botha', SHA2('Sarah#2024', 256), 'Employee'),
('tebogo.maseko', SHA2('Tebogo@Swft', 256), 'Employee'),
('michael.johnson', SHA2('Mike2024!', 256), 'Employee'),
('lindiwe.radebe', SHA2('Lindiwe@Store', 256), 'Employee'),
('blessing.sithole', SHA2('Blessing2024!', 256), 'Employee'),
('kagiso.tau', SHA2('Kagiso@Swift', 256), 'Employee'),
('precious.ngwenya', SHA2('Precious123!', 256), 'Employee'),
('themba.zulu', SHA2('Themba@2024', 256), 'Employee'),
('nandi.mthembu', SHA2('Nandi#Swift', 256), 'Employee'),
('james.williams', SHA2('JamesW2024!', 256), 'Employee'),
('zanele.dube', SHA2('ZaneleD@123', 256), 'Employee'),
('lunga.mahlangu', SHA2('Lunga2024!', 256), 'Employee'),
('priya.naidoo', SHA2('Priya@Swift', 256), 'Employee'),
('andile.kgomo', SHA2('Andile123!', 256), 'Employee'),
('charlene.pieterse', SHA2('Charlene@24', 256), 'Manager'),
('sibusiso.shabalala', SHA2('Sibu2024!', 256), 'Employee'),
('amanda.jones', SHA2('Amanda@Swift', 256), 'Employee'),
('thabo.lekota', SHA2('Thabo#2024', 256), 'Employee'),
('yolanda.adams', SHA2('Yolanda123!', 256), 'Employee'),
('mandla.ntuli', SHA2('Mandla@Swift', 256), 'Employee'),
('busisiwe.mdluli', SHA2('Busi2024!', 256), 'Employee');

-- ==============================
-- STEP 4: MUST Insert Employees Second
-- ==============================
-- Employees (with leave balance tracking)
INSERT INTO Employees (first_name, last_name, email, phone, position, hire_date, annual_leave_days, sick_leave_days, leave_days_used, user_id) VALUES
('HR', 'Admin', 'hr@swiftsend.co.za', '0116661234', 'HR Manager', '2020-01-15', 20, 12, 5.0, 1),
('Thandi', 'Mokoena', 'thandi.mokoena@swiftsend.co.za', '0821234567', 'Courier Driver', '2021-03-10', 15, 10, 3.0, 2),
('Sipho', 'Ndlovu', 'sipho.ndlovu@swiftsend.co.za', '0829876543', 'Courier Driver', '2021-06-22', 15, 10, 0, 3),
('Lerato', 'Dlamini', 'lerato.dlamini@swiftsend.co.za', '0834567890', 'Operations Manager', '2019-11-05', 20, 12, 15.0, 4),
('John', 'Smith', 'john.smith@swiftsend.co.za', '0715551234', 'Courier Driver', '2022-01-18', 15, 10, 3.0, 5),
('Nomsa', 'Khumalo', 'nomsa.khumalo@swiftsend.co.za', '0823334455', 'Administrative Assistant', '2020-08-12', 15, 10, 3.0, 6),
('Mpho', 'Mabasa', 'mpho.mabasa@swiftsend.co.za', '0847778899', 'Courier Driver', '2022-04-03', 15, 10, 0, 7),
('Zanele', 'Nkosi', 'zanele.nkosi@swiftsend.co.za', '0812223344', 'HR Coordinator', '2021-02-14', 18, 10, 0, 8),
('David', 'van der Merwe', 'david.vdm@swiftsend.co.za', '0729998877', 'Courier Driver', '2020-10-30', 15, 10, 7.0, 9),
('Fatima', 'Abrahams', 'fatima.abrahams@swiftsend.co.za', '0836665544', 'Courier Driver', '2021-09-07', 15, 10, 0, 10),
('Peter', 'Molefe', 'peter.molefe@swiftsend.co.za', '0714443322', 'Fleet Manager', '2019-05-20', 20, 12, 0, 11),
('Sarah', 'Botha', 'sarah.botha@swiftsend.co.za', '0825556677', 'Customer Service Rep', '2022-02-28', 15, 10, 0, 12),
('Tebogo', 'Maseko', 'tebogo.maseko@swiftsend.co.za', '0843332211', 'Courier Driver', '2021-12-01', 15, 10, 5.0, 13),
('Michael', 'Johnson', 'michael.johnson@swiftsend.co.za', '0717774433', 'Courier Driver', '2023-03-15', 15, 10, 3.0, 14),
('Lindiwe', 'Radebe', 'lindiwe.radebe@swiftsend.co.za', '0828889966', 'Warehouse Supervisor', '2020-07-09', 18, 10, 0, 15),
('Blessing', 'Sithole', 'blessing.sithole@swiftsend.co.za', '0821112233', 'Courier Driver', '2022-08-15', 15, 10, 4.0, 16),
('Kagiso', 'Tau', 'kagiso.tau@swiftsend.co.za', '0833334444', 'Courier Driver', '2023-01-20', 15, 10, 2.0, 17),
('Precious', 'Ngwenya', 'precious.ngwenya@swiftsend.co.za', '0745556677', 'Administrative Assistant', '2021-05-18', 15, 10, 3.0, 18),
('Themba', 'Zulu', 'themba.zulu@swiftsend.co.za', '0827778899', 'Courier Driver', '2020-03-25', 15, 10, 6.0, 19),
('Nandi', 'Mthembu', 'nandi.mthembu@swiftsend.co.za', '0849991122', 'Customer Service Rep', '2022-06-10', 15, 10, 1.0, 20),
('James', 'Williams', 'james.williams@swiftsend.co.za', '0713332244', 'Courier Driver', '2021-11-08', 15, 10, 5.0, 21),
('Zanele', 'Dube', 'zanele.dube@swiftsend.co.za', '0826665577', 'Administrative Assistant', '2023-04-12', 15, 10, 0, 22),
('Lunga', 'Mahlangu', 'lunga.mahlangu@swiftsend.co.za', '0738887766', 'Courier Driver', '2022-09-05', 15, 10, 4.0, 23),
('Priya', 'Naidoo', 'priya.naidoo@swiftsend.co.za', '0821114455', 'Customer Service Rep', '2020-12-14', 15, 10, 3.0, 24),
('Andile', 'Kgomo', 'andile.kgomo@swiftsend.co.za', '0844443322', 'Courier Driver', '2023-02-28', 15, 10, 2.0, 25),
('Charlene', 'Pieterse', 'charlene.pieterse@swiftsend.co.za', '0717776655', 'Customer Service Manager', '2019-08-19', 20, 12, 8.0, 26),
('Sibusiso', 'Shabalala', 'sibusiso.shabalala@swiftsend.co.za', '0829992233', 'Courier Driver', '2021-07-22', 15, 10, 5.0, 27),
('Amanda', 'Jones', 'amanda.jones@swiftsend.co.za', '0735558844', 'Administrative Assistant', '2022-11-30', 15, 10, 2.0, 28),
('Thabo', 'Lekota', 'thabo.lekota@swiftsend.co.za', '0843337799', 'Courier Driver', '2020-02-17', 15, 10, 7.0, 29),
('Yolanda', 'Adams', 'yolanda.adams@swiftsend.co.za', '0826669988', 'Warehouse Assistant', '2023-05-08', 15, 10, 1.0, 30),
('Mandla', 'Ntuli', 'mandla.ntuli@swiftsend.co.za', '0719993344', 'Courier Driver', '2021-10-12', 15, 10, 4.0, 31),
('Busisiwe', 'Mdluli', 'busisiwe.mdluli@swiftsend.co.za', '0842226677', 'Customer Service Rep', '2022-03-21', 15, 10, 3.0, 32);

-- Verify Employees were inserted
SELECT 'Employees inserted:', COUNT(*) FROM Employees;

-- Documents (with corrected dates and logical consistency)
INSERT INTO Documents (employee_id, doc_type, file_path, issue_date, expiry_date) VALUES
-- Thandi Mokoena
(2, 'Contract', '/docs/contracts/thandi_mokoena_contract.pdf', '2021-03-10', '2026-03-10'),
(2, 'ID', '/docs/ids/thandi_mokoena_id.pdf', '2015-06-12', NULL),
(2, 'Licence', '/docs/licences/thandi_mokoena_licence.pdf', '2020-01-15', '2026-01-15'),
(2, 'Certification', '/docs/certs/thandi_mokoena_pdp.pdf', '2021-04-20', '2026-04-20'),
-- Sipho Ndlovu
(3, 'Contract', '/docs/contracts/sipho_ndlovu_contract.pdf', '2021-06-22', '2026-06-22'),
(3, 'ID', '/docs/ids/sipho_ndlovu_id.pdf', '2018-03-08', NULL),
(3, 'Licence', '/docs/licences/sipho_ndlovu_licence.pdf', '2020-11-10', '2025-11-10'),
(3, 'Certification', '/docs/certs/sipho_ndlovu_pdp.pdf', '2021-07-15', '2026-07-15'),
-- Lerato Dlamini
(4, 'Contract', '/docs/contracts/lerato_dlamini_contract.pdf', '2019-11-05', '2025-11-05'),
(4, 'ID', '/docs/ids/lerato_dlamini_id.pdf', '2016-09-20', NULL),
-- John Smith
(5, 'Contract', '/docs/contracts/john_smith_contract.pdf', '2022-01-18', '2027-01-18'),
(5, 'ID', '/docs/ids/john_smith_id.pdf', '2019-07-14', NULL),
(5, 'Licence', '/docs/licences/john_smith_licence.pdf', '2021-08-22', '2026-08-22'),
(5, 'Certification', '/docs/certs/john_smith_pdp.pdf', '2022-02-10', '2027-02-10'),
-- Nomsa Khumalo
(6, 'Contract', '/docs/contracts/nomsa_khumalo_contract.pdf', '2020-08-12', '2025-08-12'),
(6, 'ID', '/docs/ids/nomsa_khumalo_id.pdf', '2017-04-30', NULL),
-- Mpho Mabasa
(7, 'Contract', '/docs/contracts/mpho_mabasa_contract.pdf', '2022-04-03', '2027-04-03'),
(7, 'ID', '/docs/ids/mpho_mabasa_id.pdf', '2020-02-18', NULL),
(7, 'Licence', '/docs/licences/mpho_mabasa_licence.pdf', '2020-12-05', '2025-12-05'),
(7, 'Certification', '/docs/certs/mpho_mabasa_pdp.pdf', '2022-04-28', '2027-04-28'),
-- Zanele Nkosi
(8, 'Contract', '/docs/contracts/zanele_nkosi_contract.pdf', '2021-02-14', '2026-02-14'),
(8, 'ID', '/docs/ids/zanele_nkosi_id.pdf', '2018-11-22', NULL),
-- David van der Merwe
(9, 'Contract', '/docs/contracts/david_vdm_contract.pdf', '2020-10-30', '2025-10-30'),
(9, 'ID', '/docs/ids/david_vdm_id.pdf', '2016-05-17', NULL),
(9, 'Licence', '/docs/licences/david_vdm_licence.pdf', '2020-06-14', '2025-11-14'),
(9, 'Certification', '/docs/certs/david_vdm_pdp.pdf', '2020-11-01', '2025-11-01'),
-- Fatima Abrahams
(10, 'Contract', '/docs/contracts/fatima_abrahams_contract.pdf', '2021-09-07', '2026-09-07'),
(10, 'ID', '/docs/ids/fatima_abrahams_id.pdf', '2019-01-25', NULL),
(10, 'Licence', '/docs/licences/fatima_abrahams_licence.pdf', '2021-03-19', '2026-03-19'),
(10, 'Certification', '/docs/certs/fatima_abrahams_pdp.pdf', '2021-09-30', '2026-09-30'),
-- Peter Molefe
(11, 'Contract', '/docs/contracts/peter_molefe_contract.pdf', '2019-05-20', '2025-05-20'),
(11, 'ID', '/docs/ids/peter_molefe_id.pdf', '2015-12-10', NULL),
(11, 'Licence', '/docs/licences/peter_molefe_licence.pdf', '2020-04-08', '2025-12-08'),
-- Sarah Botha
(12, 'Contract', '/docs/contracts/sarah_botha_contract.pdf', '2022-02-28', '2027-02-28'),
(12, 'ID', '/docs/ids/sarah_botha_id.pdf', '2020-08-05', NULL),
-- Tebogo Maseko
(13, 'Contract', '/docs/contracts/tebogo_maseko_contract.pdf', '2021-12-01', '2026-12-01'),
(13, 'ID', '/docs/ids/tebogo_maseko_id.pdf', '2018-10-22', NULL),
(13, 'Licence', '/docs/licences/tebogo_maseko_licence.pdf', '2021-07-30', '2026-07-30'),
(13, 'Certification', '/docs/certs/tebogo_maseko_pdp.pdf', '2022-01-15', '2027-01-15'),
-- Michael Johnson
(14, 'Contract', '/docs/contracts/michael_johnson_contract.pdf', '2023-03-15', '2028-03-15'),
(14, 'ID', '/docs/ids/michael_johnson_id.pdf', '2021-02-09', NULL),
(14, 'Licence', '/docs/licences/michael_johnson_licence.pdf', '2022-11-20', '2027-11-20'),
(14, 'Certification', '/docs/certs/michael_johnson_pdp.pdf', '2023-04-01', '2028-04-01'),
-- Lindiwe Radebe
(15, 'Contract', '/docs/contracts/lindiwe_radebe_contract.pdf', '2020-07-09', '2025-07-09'),
(15, 'ID', '/docs/ids/lindiwe_radebe_id.pdf', '2017-09-13', NULL),
-- Blessing Sithole
(16, 'Contract', '/docs/contracts/blessing_sithole_contract.pdf', '2022-08-15', '2027-08-15'),
(16, 'ID', '/docs/ids/blessing_sithole_id.pdf', '2020-05-10', NULL),
(16, 'Licence', '/docs/licences/blessing_sithole_licence.pdf', '2022-07-20', '2027-07-20'),
(16, 'Certification', '/docs/certs/blessing_sithole_pdp.pdf', '2022-08-01', '2027-08-01'),
-- Kagiso Tau
(17, 'Contract', '/docs/contracts/kagiso_tau_contract.pdf', '2023-01-20', '2028-01-20'),
(17, 'ID', '/docs/ids/kagiso_tau_id.pdf', '2021-11-15', NULL),
(17, 'Licence', '/docs/licences/kagiso_tau_licence.pdf', '2022-12-10', '2027-12-10'),
(17, 'Certification', '/docs/certs/kagiso_tau_pdp.pdf', '2023-01-05', '2028-01-05'),
-- Precious Ngwenya
(18, 'Contract', '/docs/contracts/precious_ngwenya_contract.pdf', '2021-05-18', '2026-05-18'),
(18, 'ID', '/docs/ids/precious_ngwenya_id.pdf', '2019-03-22', NULL),
-- Themba Zulu
(19, 'Contract', '/docs/contracts/themba_zulu_contract.pdf', '2020-03-25', '2026-03-25'),
(19, 'ID', '/docs/ids/themba_zulu_id.pdf', '2017-08-14', NULL),
(19, 'Licence', '/docs/licences/themba_zulu_licence.pdf', '2020-02-15', '2025-12-15'),
(19, 'Certification', '/docs/certs/themba_zulu_pdp.pdf', '2020-03-10', '2025-12-10'),
-- Nandi Mthembu
(20, 'Contract', '/docs/contracts/nandi_mthembu_contract.pdf', '2022-06-10', '2027-06-10'),
(20, 'ID', '/docs/ids/nandi_mthembu_id.pdf', '2020-09-05', NULL),
-- James Williams
(21, 'Contract', '/docs/contracts/james_williams_contract.pdf', '2021-11-08', '2026-11-08'),
(21, 'ID', '/docs/ids/james_williams_id.pdf', '2019-06-30', NULL),
(21, 'Licence', '/docs/licences/james_williams_licence.pdf', '2021-10-12', '2026-10-12'),
(21, 'Certification', '/docs/certs/james_williams_pdp.pdf', '2021-11-01', '2026-11-01'),
-- Zanele Dube
(22, 'Contract', '/docs/contracts/zanele_dube_contract.pdf', '2023-04-12', '2028-04-12'),
(22, 'ID', '/docs/ids/zanele_dube_id.pdf', '2021-12-08', NULL),
-- Lunga Mahlangu
(23, 'Contract', '/docs/contracts/lunga_mahlangu_contract.pdf', '2022-09-05', '2027-09-05'),
(23, 'ID', '/docs/ids/lunga_mahlangu_id.pdf', '2020-07-18', NULL),
(23, 'Licence', '/docs/licences/lunga_mahlangu_licence.pdf', '2022-08-15', '2027-08-15'),
(23, 'Certification', '/docs/certs/lunga_mahlangu_pdp.pdf', '2022-08-28', '2027-08-28'),
-- Priya Naidoo
(24, 'Contract', '/docs/contracts/priya_naidoo_contract.pdf', '2020-12-14', '2025-12-14'),
(24, 'ID', '/docs/ids/priya_naidoo_id.pdf', '2018-04-20', NULL),
-- Andile Kgomo
(25, 'Contract', '/docs/contracts/andile_kgomo_contract.pdf', '2023-02-28', '2028-02-28'),
(25, 'ID', '/docs/ids/andile_kgomo_id.pdf', '2021-09-12', NULL),
(25, 'Licence', '/docs/licences/andile_kgomo_licence.pdf', '2023-01-20', '2028-01-20'),
(25, 'Certification', '/docs/certs/andile_kgomo_pdp.pdf', '2023-02-15', '2028-02-15'),
-- Charlene Pieterse
(26, 'Contract', '/docs/contracts/charlene_pieterse_contract.pdf', '2019-08-19', '2025-08-19'),
(26, 'ID', '/docs/ids/charlene_pieterse_id.pdf', '2016-11-28', NULL),
-- Sibusiso Shabalala
(27, 'Contract', '/docs/contracts/sibusiso_shabalala_contract.pdf', '2021-07-22', '2026-07-22'),
(27, 'ID', '/docs/ids/sibusiso_shabalala_id.pdf', '2019-02-10', NULL),
(27, 'Licence', '/docs/licences/sibusiso_shabalala_licence.pdf', '2021-06-05', '2026-06-05'),
(27, 'Certification', '/docs/certs/sibusiso_shabalala_pdp.pdf', '2021-07-10', '2026-07-10'),
-- Amanda Jones
(28, 'Contract', '/docs/contracts/amanda_jones_contract.pdf', '2022-11-30', '2027-11-30'),
(28, 'ID', '/docs/ids/amanda_jones_id.pdf', '2020-10-22', NULL),
-- Thabo Lekota
(29, 'Contract', '/docs/contracts/thabo_lekota_contract.pdf', '2020-02-17', '2026-02-17'),
(29, 'ID', '/docs/ids/thabo_lekota_id.pdf', '2017-05-08', NULL),
(29, 'Licence', '/docs/licences/thabo_lekota_licence.pdf', '2020-01-10', '2026-01-10'),
(29, 'Certification', '/docs/certs/thabo_lekota_pdp.pdf', '2020-02-05', '2026-02-05'),
-- Yolanda Adams
(30, 'Contract', '/docs/contracts/yolanda_adams_contract.pdf', '2023-05-08', '2028-05-08'),
(30, 'ID', '/docs/ids/yolanda_adams_id.pdf', '2021-03-15', NULL),
-- Mandla Ntuli
(31, 'Contract', '/docs/contracts/mandla_ntuli_contract.pdf', '2021-10-12', '2026-10-12'),
(31, 'ID', '/docs/ids/mandla_ntuli_id.pdf', '2019-07-25', NULL),
(31, 'Licence', '/docs/licences/mandla_ntuli_licence.pdf', '2021-09-20', '2026-09-20'),
(31, 'Certification', '/docs/certs/mandla_ntuli_pdp.pdf', '2021-10-01', '2026-10-01'),
-- Busisiwe Mdluli
(32, 'Contract', '/docs/contracts/busisiwe_mdluli_contract.pdf', '2022-03-21', '2027-03-21'),
(32, 'ID', '/docs/ids/busisiwe_mdluli_id.pdf', '2020-01-12', NULL);

-- Leave Requests (with proper tracking and approval info)
INSERT INTO LeaveRequests (employee_id, leave_type, start_date, end_date, days_requested, reason, status, approved_by, approval_date) VALUES
(2, 'Annual', '2025-10-15', '2025-10-17', 3.0, 'Family event', 'Approved', 1, '2025-10-10'),
(3, 'Annual', '2025-11-01', '2025-11-05', 5.0, 'Annual leave', 'Pending', NULL, NULL),
(5, 'Sick', '2025-09-25', '2025-09-27', 3.0, 'Medical appointment', 'Approved', 1, '2025-09-24'),
(7, 'Annual', '2025-10-20', '2025-10-22', 3.0, 'Personal matters', 'Pending', NULL, NULL),
(9, 'Annual', '2025-08-10', '2025-08-17', 7.0, 'Holiday', 'Approved', 4, '2025-08-05'),
(10, 'Study', '2025-11-10', '2025-11-15', 5.0, 'Study leave', 'Pending', NULL, NULL),
(4, 'Annual', '2025-12-20', '2026-01-05', 15.0, 'Year-end break', 'Approved', 1, '2025-12-10'),
(6, 'Sick', '2025-10-01', '2025-10-03', 3.0, 'Sick leave', 'Approved', 1, '2025-09-30'),
(12, 'Annual', '2025-11-25', '2025-11-29', 5.0, 'Family wedding', 'Pending', NULL, NULL),
(13, 'Annual', '2025-09-15', '2025-09-20', 5.0, 'Annual leave', 'Approved', 4, '2025-09-10'),
(14, 'Sick', '2025-10-08', '2025-10-10', 3.0, 'Medical procedure', 'Rejected', 1, '2025-10-07'),
(15, 'Annual', '2025-12-01', '2025-12-15', 14.0, 'Holiday', 'Pending', NULL, NULL),
(16, 'Annual', '2025-08-20', '2025-08-24', 4.0, 'Family visit', 'Approved', 4, '2025-08-15'),
(17, 'Annual', '2025-11-18', '2025-11-20', 2.0, 'Personal matters', 'Pending', NULL, NULL),
(19, 'Annual', '2025-07-10', '2025-07-17', 6.0, 'Holiday', 'Approved', 11, '2025-07-05'),
(21, 'Annual', '2025-09-01', '2025-09-05', 5.0, 'Annual leave', 'Approved', 4, '2025-08-28'),
(23, 'Annual', '2025-10-25', '2025-10-28', 4.0, 'Personal matters', 'Pending', NULL, NULL),
(24, 'Sick', '2025-09-18', '2025-09-20', 3.0, 'Medical appointment', 'Approved', 26, '2025-09-17'),
(25, 'Annual', '2025-11-22', '2025-11-23', 2.0, 'Family event', 'Pending', NULL, NULL),
(26, 'Annual', '2025-08-05', '2025-08-12', 8.0, 'Holiday', 'Approved', 1, '2025-07-30'),
(27, 'Annual', '2025-09-08', '2025-09-12', 5.0, 'Annual leave', 'Approved', 11, '2025-09-05'),
(28, 'Annual', '2025-11-15', '2025-11-16', 2.0, 'Personal matters', 'Pending', NULL, NULL),
(29, 'Annual', '2025-06-15', '2025-06-21', 7.0, 'Holiday', 'Approved', 4, '2025-06-10'),
(30, 'Sick', '2025-10-14', '2025-10-14', 1.0, 'Medical appointment', 'Approved', 1, '2025-10-13'),
(31, 'Annual', '2025-10-28', '2025-10-31', 4.0, 'Personal matters', 'Pending', NULL, NULL),
(32, 'Sick', '2025-09-22', '2025-09-24', 3.0, 'Sick leave', 'Approved', 26, '2025-09-21');

-- Expiry Alerts (only for documents with expiry dates, with future/recent alert dates)
-- Alerts are set for 60 days before expiry (2 months warning) and 30 days before expiry
INSERT INTO ExpiryAlerts (document_id, alert_date, status) VALUES
-- Sipho's Licence expires 2025-11-10
(7, '2025-09-11', 'Read'),      -- 60 days before
(7, '2025-10-11', 'Unread'),    -- 30 days before
-- Lerato's Contract expires 2025-11-05
(9, '2025-09-06', 'Unread'),    -- 60 days before
(9, '2025-10-06', 'Unread'),    -- 30 days before
-- David's Contract expires 2025-10-30
(23, '2025-09-01', 'Read'),     -- 60 days before
(23, '2025-10-01', 'Unread'),   -- 30 days before
-- David's Licence expires 2025-11-14
(25, '2025-09-15', 'Unread'),   -- 60 days before
(25, '2025-10-15', 'Unread'),   -- 30 days before
-- David's Certification expires 2025-11-01
(26, '2025-09-02', 'Read'),     -- 60 days before
(26, '2025-10-02', 'Unread'),   -- 30 days before
-- Mpho's Licence expires 2025-12-05
(19, '2025-10-06', 'Unread'),   -- 60 days before
-- Peter's Contract expires 2025-05-20 (EXPIRED)
(30, '2025-03-21', 'Read'),     -- 60 days before (already passed)
(30, '2025-04-20', 'Read'),     -- 30 days before (already passed)
-- Peter's Licence expires 2025-12-08
(32, '2025-10-09', 'Unread'),   -- 60 days before
-- Thandi's Licence expires 2026-01-15
(3, '2025-11-16', 'Unread'),    -- 60 days before
-- Themba's Licence expires 2025-12-15
(65, '2025-10-16', 'Unread'),   -- 60 days before
-- Themba's Certification expires 2025-12-10
(66, '2025-10-11', 'Unread'),   -- 60 days before
-- Priya's Contract expires 2025-12-14
(80, '2025-10-15', 'Unread'),   -- 60 days before
-- Charlene's Contract expires 2025-08-19 (EXPIRED)
(86, '2025-06-20', 'Read'),     -- 60 days before
(86, '2025-07-20', 'Read'),     -- 30 days before
-- Lindiwe's Contract expires 2025-07-09 (EXPIRED)
(45, '2025-05-10', 'Read'),     -- 60 days before
(45, '2025-06-09', 'Read'),     -- 30 days before
-- Nomsa's Contract expires 2025-08-12 (EXPIRED)
(15, '2025-06-13', 'Read'),     -- 60 days before
(15, '2025-07-13', 'Read');     -- 30 days before
