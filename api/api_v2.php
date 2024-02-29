<?php
function readCategoriesFromCSV($filename) {
    $categories = [];
    if (($handle = fopen($filename, "r")) !== FALSE) {
        fgetcsv($handle, 1000, ";"); // Ignorar a linha de cabeçalho
        while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
            $emoji = $data[14]; // Coluna 'O' (emj2)
            $category = $data[10]; // Coluna 'K' (cat2)
            $color = $data[7]; // Coluna 'H' (cor1)
            $sigla = $data[13]; // Coluna 'N' (sigla)
            $categories[] = ['emoji' => $emoji, 'category' => $category, 'color' => $color, 'sigla' => $sigla];
        }
        fclose($handle);
    }
    return $categories;
}

$categories = readCategoriesFromCSV('CAT.csv');
$searchTypes = ['ean', 'produto', 'marca', 'categoria', 'palavra', 'prod_cat'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $searchType = $_POST['searchType'] ?? '';
    $searchValue = $_POST['searchValue'] ?? '';
    $categoryId = $_POST['categoryId'] ?? '';
    $userId = $_POST['userId'] ?? '';
    $inputLimit = $_POST['inputLimit'] ?? 10;
    $generateJSON = isset($_POST['generateJSON']);

    $apiUrl = "http://www.hiperhyped.com.br/api/search_v3.php?userId=$userId&searchType=$searchType&inputLimit=$inputLimit";
    if ($searchType == "prod_cat") {
        $apiUrl .= "&nome=$searchValue&sigla=$categoryId";
    } else {
        $apiUrl .= "&$searchType=$searchValue";
    }

    if ($generateJSON) {
        // Faz a chamada à API e obtém os dados
        $jsonData = file_get_contents($apiUrl);
    
        // Define o cabeçalho para forçar o download do arquivo
        header('Content-Type: application/json');
        header('Content-Disposition: attachment; filename="search_results.json"');
    
        // Envia os dados para o navegador, iniciando o download
        echo $jsonData;
        exit; // Encerra a execução do script para evitar a renderização da página HTML
    }
       
    echo "Chamando API: $apiUrl";
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>HiperHyped API</title>
    <style>
        .top-bar {
            height: 80px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            padding: 0 20px;
        }
        .form-element {
            margin-right: 20px;
        }
        .form-element label {
            display: block;
            margin-bottom: 5px;
        }
        /* Estilizações adicionais aqui */
    </style>
</head>
<body>
<div class="top-bar">
        <img src="HH93.png" alt="Logo HiperHyped" style="height: 60px; margin-right: 20px"> <!-- Substitua pelo caminho correto do logo -->
        <form method="post" style="display: flex; align-items: center;">
            <div class="form-element">
                <label for="searchType">Tipo de Busca</label>
                <select name="searchType" id="searchType">
                    <?php foreach ($searchTypes as $type): ?>
                        <option value="<?= $type ?>"><?= ucfirst($type) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-element">
                <label for="searchValue">Valor de Busca</label>
                <input type="text" name="searchValue" id="searchValue" placeholder="Digite aqui...">
            </div>

            <div class="form-element">
                <label for="categoryId">Categoria</label>
                <select name="categoryId" id="categoryId">
                    <?php foreach ($categories as $category): ?>
                        <option value="<?= $category['sigla'] ?>" style="color: <?= $category['color'] ?>;"><?= $category['emoji'] . ' ' . $category['category'] ?></option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-element">
                <label for="userId">User</label>
                <select name="userId" id="userId">
                    <?php for ($i = 37; $i <= 80; $i++): ?>
                        <option value="<?= $i ?>"><?= $i ?></option>
                    <?php endfor; ?>
                </select>
            </div>

            <div class="form-element">
                <label for="inputLimit">Limite</label>
                <select name="inputLimit" id="inputLimit">
                    <?php foreach ([10, 20, 50, 100, 200, 500, 1000] as $limit): ?>
                        <option value="<?= $limit ?>"><?= $limit ?></option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-element">
                <label for="generateJSON">Gerar JSON?</label>
                <input type="checkbox" name="generateJSON" id="generateJSON">
            </div>

            <div class="form-element">
                <button type="submit">Confirmar</button>
            </div>
        </form>
    </div>


    <!-- Aqui, você pode adicionar a parte principal da página, incluindo a exibição dos resultados da API -->
    <!-- Resultados da API serão exibidos aqui -->

</body>
</html>

