CREATE TABLE IF NOT EXISTS users (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    USERNAME VARCHAR(255) NOT NULL UNIQUE,
    PASSWORD_HASH VARCHAR(255) NOT NULL,
    ROLE ENUM('admin', 'user') NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS tickets (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID INT NOT NULL,
    TITLE VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    STATUS ENUM('open', 'in_progress', 'closed') NOT NULL DEFAULT 'open', 
    PRIORITY ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'low',
    FOREIGN KEY (USER_ID) REFERENCES users(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS comments (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TICKET_ID INT NOT NULL,
    USER_ID INT NOT NULL,
    COMMENT_TEXT TEXT,
    FOREIGN KEY (USER_ID) REFERENCES users(ID) ON DELETE CASCADE,
    FOREIGN KEY (TICKET_ID) REFERENCES tickets(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS attachments (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TICKET_ID INT NOT NULL,
    ORIGINAL_FILENAME VARCHAR(255) NOT NULL,
    STORED_PATH VARCHAR(255) NOT NULL,
    FOREIGN KEY (TICKET_ID) REFERENCES tickets(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS system_settings (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    SETTING_NAME VARCHAR(255) NOT NULL UNIQUE,
    SETTING_VALUE VARCHAR(255)
);

-- Passwords:
-- 'admin123' -> d033e22ae348aeb5660fc2140aec35850c4da997
-- 'user123'  -> 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8 (password)
-- 'habib2026'-> 9d4e1e23bd5b727046a9e3b4b7db57bd8d6ee684
INSERT INTO users (ID, USERNAME, PASSWORD_HASH, ROLE) VALUES
(1, 'admin', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'admin'),
(2, 'habib', '9d4e1e23bd5b727046a9e3b4b7db57bd8d6ee684', 'user'),
(3, 'victim_user', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'user');

INSERT INTO tickets (ID, USER_ID, TITLE, DESCRIPTION, STATUS, PRIORITY) VALUES
(1, 2, 'Cannot access internal dashboard', 'I keep getting 403 Forbidden when trying to open /internal route.', 'open', 'high'),
(2, 3, 'Printer in lab not responding', 'The network printer on subnet 192.168.1.0/24 stopped printing tickets.', 'in_progress', 'medium'),
(3, 2, 'Request for Docker permission update', 'Need rootless docker group access on testing VM.', 'closed', 'low');

INSERT INTO comments (ID, TICKET_ID, USER_ID, COMMENT_TEXT) VALUES
(1, 1, 1, 'Please confirm your IP address and check if your VPN tunnel is up.'),
(2, 1, 2, 'My IP is 10.10.14.5, VPN is connected but still facing 403.'),
(3, 2, 1, 'Investigating the print spooler service now.');

INSERT INTO attachments (ID, TICKET_ID, ORIGINAL_FILENAME, STORED_PATH) VALUES
(1, 1, 'error_screenshot.png', '/var/uploads/tickets/1/error_screenshot_a8f9.png'),
(2, 1, 'network_log.txt', '/var/uploads/tickets/1/network_log_b2c1.txt'),
(3, 2, 'printer_status.pdf', '/var/uploads/tickets/2/printer_status_c3d4.pdf');

INSERT INTO system_settings (ID, SETTING_NAME, SETTING_VALUE) VALUES
(1, 'upload_max_size_mb', '10'),
(2, 'allowed_file_extensions', 'png,jpg,pdf,txt'),
(3, 'maintenance_mode', 'false'),
(4, 'app_version', '1.0.0-sec-lab');