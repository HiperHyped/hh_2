<?php
include_once 'DBGrid.php';

header('Content-Type: application/json');

function getData() {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        return json_decode(file_get_contents('php://input'), true);
    } else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        return $_GET;
    } else {
        return [];
    }
}

$data = getData();

$sigla = $data['sigla'] ?? '';
$gridLimit = $data['gridLimit'] ?? 10; // Limite padrão
$userId = $data['userId'] ?? '';

$dbGrid = new DBGrid();
try {
    $productList = $dbGrid->getProductsForGridV3($sigla, $gridLimit, $userId);
    // Chamada opcional para atualizar perfil do usuário
    // $dbGrid->updateUserProfile($userId);
    echo json_encode(['success' => true, 'data' => $productList]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>
