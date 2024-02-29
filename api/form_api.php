<?php

include_once 'DBSearch.php';
include_once 'DBUser.php';

// Funções para gerar quadradinhos
function getColorForDimension($value) {
    $red = (1 - $value) * 255;
    $green = $value * 255;
    $blue = 0;
    return sprintf("#%02x%02x%02x", $red, $green, $blue);
}

function displayDimension($row, $dim, $sigla) {
    $dimValue = floatval($row[$dim]);
    $color = getColorForDimension($dimValue);
    echo "<div class='tooltip'>";
    echo "<div class='dim-box' style='background-color: $color;'></div>";
    echo "<span class='tooltiptext'>$dim - $sigla: " . number_format($dimValue, 2) . "</span>";
    echo "</div>";
}

function fetchUserProfile($userId) {
    // Encontrar o perfil do usuário específico
    foreach ($users as $userProfile) {
        if ($userProfile['user_id'] == $userId) {
            echo "<div class='dimensions-row'>";
                echo "<div class='dimensions-section'>";
                    echo "<h6>CAT</h6>";
                    displayDimension($userProfile, 'avg_D2', 'CPC');
                    displayDimension($userProfile, 'avg_D3', 'CSC');
                    displayDimension($userProfile, 'avg_D9', 'CPM');
                echo "</div>"; // Fechando CAT
                
                echo "<div class='dimensions-section'>";
                    echo "<h6>BRAND</h6>";
                    displayDimension($userProfile, 'avg_D1', 'MPC');
                    displayDimension($userProfile, 'avg_D4', 'MUD');
                    displayDimension($userProfile, 'avg_D5', 'MUPM');
                echo "</div>"; // Fechando BRAND
                
                echo "<div class='dimensions-section'>";
                    echo "<h6>PRICE</h6>";
                    displayDimension($userProfile, 'avg_D6', 'PPM');
                    displayDimension($userProfile, 'avg_D7', 'PV');
                    displayDimension($userProfile, 'avg_D8', 'PP');
                echo "</div>"; // Fechando PRICE
            echo "</div>"; // Fechando dimensions-row 
            break;
        }
    }
}

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

function getData() {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        return json_decode(file_get_contents('php://input'), true);
    } else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        return $_GET;
    } else {
        return [];
    }
}

$categories = readCategoriesFromCSV('CAT.csv');
$searchTypes = ['ean', 'product', 'brand', 'category', 'word', 'prod_cat'];

// Crie uma instância de DBUser
$dbUser = new DBUser();
$users = $dbUser->getAllUserProfiles();

function search() {

    $searchType = $_POST['searchType'];
    $searchValue = $_POST['searchValue'];  
    $categoryId = $_POST['categoryId'];
    $userId = $_POST['userId'];
    $inputLimit = $_POST['inputLimit'];
  
    $apiUrl = "http://www.hiperhyped.com.br/api/search_v3.php"; 
    $apiUrl .= "?userId={$userId}&searchType={$searchType}";
    $apiUrl .= "&inputLimit={$inputLimit}";
  
    if($searchType == "prod_cat") {
      $apiUrl .= "&nome={$searchValue}&sigla={$categoryId}";
    } else {
      $apiUrl .= "&{$searchType}={$searchValue}";
    }
     
    // Chama a API
    $result = file_get_contents($apiUrl);
     
    // Exibe resultados
    echo $result;  
  }
  
  if(isset($_POST['confirm'])) {
    search(); 
  }
?>

<!DOCTYPE html>
<html>
<head>
    <title>HiperHyped API</title>
    <style>
        body, select, input, button, label {
            font-family: Arial, sans-serif; /* Definindo a fonte para Arial */
        }
        .top-bar {
            height: 80px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            padding: 0 20px;
        }
        .form-element {
            margin-right: 10px;
            display: flex;
            flex-direction: column;
            margin-bottom: 11px; /* Espaço entre os campos do formulário */
        }
        .form-element label {
            margin-bottom: 5px; /* Espaço entre o label e o campo */
        }
    </style>
</head>
<body>

    <div class="top-bar">
        <img src="HH93.png" alt="Logo HiperHyped" style="height: 60px; margin-right: 20px"> <!-- Substitua pelo caminho correto do logo -->
        
        <form method="post" style="display: flex; align-items: center;" action="search_v3.php" method="post" target="resultFrame">
            
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
                <select name="userId" id="userId" onchange="fetchUserProfile(this.value)">
                    <?php foreach ($users as $user): ?>
                        <option value="<?= $user['user_id'] ?>"><?= $user['user_login'] ?></option>
                    <?php endforeach; ?>
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
                <button type="submit" name="confirm">Confirmar</button>
            </div>
        </form>
    </div>
    <script>
        window.onload = function() {
            var searchTypeSelect = document.getElementById('searchType');
            var categoryIdSelect = document.getElementById('categoryId');
            var categoryLabel = document.querySelector('label[for="categoryId"]');

            // Função para ativar ou desativar categoryId com base em searchType
            function toggleCategoryDropdown() {
                var selectedValue = searchTypeSelect.value;
                if (selectedValue === 'category' || selectedValue === 'prod_cat') {
                    categoryIdSelect.disabled = false;
                    categoryLabel.style.opacity = 1;
                } else {
                    categoryIdSelect.disabled = true;
                    categoryLabel.style.opacity = 0.5;
                }
            }

            // Defina o valor inicial e aplique a lógica
            searchTypeSelect.value = 'prod_cat';
            toggleCategoryDropdown();

            // Event listener para mudanças em searchType
            searchTypeSelect.addEventListener('change', toggleCategoryDropdown);
        };
    </script>
</body>
</html>