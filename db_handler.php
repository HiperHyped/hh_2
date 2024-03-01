<?php
// Enable error reporting
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
ini_set('error_log', '/php_error.log');

error_reporting(E_ALL);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$host = 'hhdbv1.mysql.dbaas.com.br';
$db   = 'hhdbv1';
$user = 'hhdbv1';
$pass = 'HHDBv1!';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$opt = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $opt);
    error_log("Connected to the database");
} catch (PDOException $e) {
    error_log("PDO error occurred: " . $e->getMessage());
    die(json_encode(['error' => 'Failed to connect to the database']));
}

$data = json_decode(file_get_contents('php://input'), true);

if (!is_array($data)) {
    error_log("No valid data received");
    die(json_encode(['error' => 'No valid data received']));
}

if (!isset($data['sql']) || !isset($data['values'])) {
    error_log("Required data keys not present");
    die(json_encode(['error' => 'Required data keys not present']));
}

$sql = $data['sql'];
$values = $data['values'];

if (empty($sql)) {
    error_log("SQL query is empty");
    die(json_encode(['error' => 'SQL query is empty']));
}

try {
    $stmt = $pdo->prepare($sql);
    $stmt->execute($values);
    $data = $stmt->fetchAll();

    // Debug $data variable after fetchAll()
    error_log("Fetched data: " . print_r($data, true));

    echo json_encode($data);
} catch (PDOException $e) {
    error_log("PDO error occurred: " . $e->getMessage());
    die(json_encode(['error' => 'Failed to execute SQL query']));
}
?>
