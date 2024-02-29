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
    $sigla = $_POST['sigla'];
    $inputLimit = $_POST['inputLimit'];
  
    // Coleta os valores das dimensões D1 a D9 do POST
    $dimensions = [];
    for ($i = 1; $i <= 9; $i++) {
        $dimKey = "D{$i}";
        $dimensions[$dimKey] = $_POST[$dimKey] ?? '0'; // Default to '0' if not set
    }

    $apiUrl = "http://www.hiperhyped.com.br/api/search_v4.php"; 
    $apiUrl .= "?searchType={$searchType}&inputLimit={$inputLimit}";
  
    // Adiciona parâmetros condicionalmente com base no tipo de pesquisa
    if ($searchType == "prod_cat") {
        $apiUrl .= "&searchValue={$searchValue}&sigla={$sigla}";
    } else {
        $apiUrl .= "&searchValue={$searchValue}";
    }

    // Adiciona as dimensões à URL
    foreach ($dimensions as $key => $value) {
        $apiUrl .= "&{$key}=" . urlencode($value);
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
        
        .sliders-container {
            display: flex;
            justify-content: center;
            width: 100%;
        }
        .slider-group {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 0 20px;
        }
        .slider-label {
            margin: 5px;
        }
        .slider {
            width: 70px; /* Ajuste conforme necessário para o seu layout */
            -webkit-appearance: none; /* Override para sliders no WebKit */
            /*width: 100%;  Largura completa dentro do seu container */
            height: 5px; /* Espessura reduzida do slider */
            background: linear-gradient(to right, red, green); /* Gradiente do vermelho para o verde */
            outline: none; /* Remove o outline ao focar */
        }

        .slider::-webkit-slider-thumb {
            -webkit-appearance: none; /* Remove a aparência padrão */
            background: black; /* Cor do thumb */
            width: 12px; /* Largura do thumb */
            height: 12px; /* Altura do thumb */
            border-radius: 50%; /* Faz o thumb circular */
            cursor: pointer; /* Muda o cursor para ponteiro */
        }


        
    </style>
</head>
<body>

    <div class="top-bar">
        <img src="HH93.png" alt="Logo HiperHyped" style="height: 60px; margin-right: 20px"> <!-- Substitua pelo caminho correto do logo -->
        
        <form method="post" style="display: flex; align-items: center;" action="search_v4.php" method="post" target="resultFrame">
            
            <div class="form-element">
                <label for="searchType">Busca</label>
                <select name="searchType" id="searchType">
                    <?php foreach ($searchTypes as $type): ?>
                        <option value="<?= $type ?>" <?= $type === 'prod_cat' ? 'selected' : '' ?>><?= ucfirst($type) ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            
            <div class="form-element">
                <label for="searchValue">Valor de Busca</label>
                <input type="text" name="searchValue" id="searchValue" placeholder="Digite aqui...">
            </div>

            <div class="form-element">
                <label for="sigla">Categoria</label>
                <select name="sigla" id="sigla">
                    <?php foreach ($categories as $category): ?>
                        <option value="<?= $category['sigla'] ?>" style="color: <?= $category['color'] ?>;"><?= $category['emoji'] . ' ' . $category['category'] ?></option>
                    <?php endforeach; ?>
                </select>
            </div>




            <!---------------------------------------------------->
            <div class="sliders-container">
                <?php 
                $sliderGroups = [
                    'Categoria' => [2, 3, 9],
                    'Marca' => [1, 4, 5],
                    'Preço' => [6, 7, 8]
                ];

                foreach ($sliderGroups as $groupLabel => $sliders) : ?>
                    <div class="slider-group">
                        <span><?php echo $groupLabel; ?></span>
                        <?php foreach ($sliders as $d) : ?>
                            <div class="slider-element">
                                <label class="slider-label" for="D<?php echo $d; ?>">D<?php echo $d; ?></label>
                                <input type="range" id="D<?php echo $d; ?>" name="D<?php echo $d; ?>" min="0" max="1" step="0.1" value="0.5" class="slider">
                                <span id="valueD<?php echo $d; ?>" class="slider-value">0.5</span>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endforeach; ?>
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
            var siglaSelect = document.getElementById('sigla');
            var siglaLabel = document.querySelector('label[for="sigla"]');
            var searchValueInput = document.getElementById('searchValue');
            var searchValueLabel = document.querySelector('label[for="searchValue"]');

            // Função para ativar ou desativar sigla e searchValue com base em searchType
            function toggleFormElements() {
                var selectedValue = searchTypeSelect.value;

                // Lógica para sigla
                if (selectedValue === 'category' || selectedValue === 'prod_cat') {
                    siglaSelect.disabled = false;
                    siglaLabel.style.opacity = 1;
                } else {
                    siglaSelect.disabled = true;
                    siglaLabel.style.opacity = 0.5;
                }

                // Lógica para searchValue
                if (selectedValue === 'category') {
                    searchValueInput.disabled = true;
                    searchValueLabel.style.opacity = 0.5;
                } else {
                    searchValueInput.disabled = false;
                    searchValueLabel.style.opacity = 1;
                }
            }

            // Defina o valor inicial e aplique a lógica
            toggleFormElements();

            // Event listener para mudanças em searchType
            searchTypeSelect.addEventListener('change', toggleFormElements);
        };

        document.querySelectorAll('.slider').forEach(function(slider) {
            slider.addEventListener('input', function() {
                var id = this.id;
                var value = parseFloat(this.value).toFixed(1);
                document.getElementById('value' + id).textContent = value;
            });
        });

    </script>
</body>
</html>