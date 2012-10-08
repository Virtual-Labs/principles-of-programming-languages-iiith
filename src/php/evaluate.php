<?php

$conn = ssh2_connect('10.2.48.13', 22);
ssh2_auth_password($conn, 'evaluator', '123456');
ssh2_scp_send($conn, 'test_file', '/tmp/test_file', 0644);

$stream = ssh2_exec($conn, 'sudo -u testuser1 /usr/bin/evaluate /tmp/test_file');
stream_set_blocking($stream, true);
echo stream_get_contents($stream);

