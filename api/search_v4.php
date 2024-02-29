<?php
include_once 'DBSearch.php';

function getData() {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        return $_POST; // Pega os dados do formulário enviado
    } else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        return $_GET;
    } else {
        return [];
    }
}

$data = getData();
$searchType = $data['searchType'] ?? 'prod_cat';
$inputLimit = $data['inputLimit'] ?? 10;

// Inicializa o array de dimensões com valores padrão
$dimensions = [];
for ($i = 1; $i <= 9; $i++) {
    $dimensions['D' . $i] = $data['D' . $i] ?? 0.0;
}

$searchProduct = [
    'searchType' => $searchType,
    'searchValue' => $data['searchValue'] ?? '',
    'sigla' => $data['sigla'] ?? ''
];

// Cria uma instância de DBSearch e chama a função searchProductByDimensions
$dbSearch = new DBSearch();
$result = $dbSearch->searchProductByDimensions($searchProduct, $inputLimit, $dimensions);

// Prepara o JSON para download, se necessário
$jsonForDownload = '';
if (isset($data['generateJSON']) && $result) {
    // Codifica o resultado em JSON
    $jsonForDownload = json_encode($result);

    // Define o nome do arquivo de download
    $searchTypeMap = ['ean' => 'E', 'product' => 'P', 'category' => 'C', 'brand' => 'B', 'word' => 'W', 'prod_cat' => 'PC'];
    $searchTypeSigla = isset($searchTypeMap[strtolower($searchType)]) ? $searchTypeMap[strtolower($searchType)] : 'o';
    $searchValueClean = isset($data['searchValue']) ? preg_replace('/[^A-Za-z0-9\-]/', '_', $data['searchValue']) : 'o';
    $siglaClean = isset($data['sigla']) ? preg_replace('/[^A-Za-z0-9\-]/', '_', $data['sigla']) : 'o';
    $fileName = "{$searchTypeSigla}_{$searchValueClean}_{$siglaClean}_{$inputLimit}.json";
}

// Seu código para exibir os resultados...
// ...

// No final do script, verifica se deve fazer o download do JSON
if ($jsonForDownload) {
    // Envia os cabeçalhos apropriados para forçar o download
    header('Content-Description: File Transfer');
    header('Content-Type: application/json');
    header('Content-Disposition: attachment; filename="' . basename($fileName) . '"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . strlen($jsonForDownload));
    echo $jsonForDownload;
    exit; // Encerra o script após o download do JSON
}

// Se o checkbox 'generateJSON' não estiver marcado ou se o resultado estiver vazio,
// o script continuará a execução para realizar outras ações necessárias.


echo "<style>";

echo "  .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px; }";
echo "  .product-item { position: relative; border: 1px solid #ddd; padding: 5px; text-align: center; }";
echo "  .product-item img { max-width: 100%; height: 150px; object-fit: cover; }"; 
echo "  .counter { position: absolute; top: 8px; left: 8px; color: #FFF; background-color: #000; padding: 2px 5px; border-radius: 10px; font-size: 14px; z-index: 2; }";
echo "  .price-tag { position: absolute; top: 8px; right: 8px; background-color: rgba(255,255,255,0.85); padding: 2px 5px; border-radius: 5px; color: #333; font-weight: bold; font-size: 14px; }";
echo "  .dim-box { width: 12px; height: 12px; margin: 1px; }";
echo "  .cluster-box { width: 14px; height: 14px; display: flex; align-items: center; justify-content: center; margin: auto; font-size: 10px; }";
echo "  .tooltip { position: relative; display: inline-block; }";
echo "  .product-name, .product-brand, .product-price { font-size: 12px; line-height: 1.2; margin: 0px; height: auto; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }";
echo "  .tooltip .tooltiptext { visibility: hidden; width: 120px; background-color: black; color: #fff; text-align: center;";
echo "      border-radius: 6px; padding: 5px 0; position: absolute; z-index: 1; bottom: 125%; left: 50%; margin-left: -60px;";
echo "      opacity: 0; transition: opacity 0.3s; }";
echo "  .tooltip:hover .tooltiptext { visibility: visible; opacity: 1; }";
echo "  .dimensions-row { display: flex; gap: 0; }";
echo "  .dimensions-section { flex: 1; padding: 5px 0; margin: 0px; text-align: center; border-right: 1px solid #ccc; box-sizing: border-box; }";
echo "  .dimensions-section:last-child { border-right: none; }";
echo "  h6 { margin: 0; }"; 
echo "  h5 { margin: 0; }"; 
echo "  p { margin: 0; }"; 
echo "</style>";

echo "<div class='product-grid'>";

$counter = 1; // Iniciar o contador

foreach ($result as $row) {
    $imageUrl = "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/" .
                substr($row['sigla'], 0, 1) . "/" .
                substr($row['sigla'], 1, 2) . "/" .
                substr($row['sigla'], 3) . "/" .
                $row['prod_image'];
    
    $formattedPrice = "R$ " . number_format($row['prod_price'], 2, ',', '.');

    echo "<div class='product-item'>";
        echo "<div class='counter'>$counter</div>"; // Mostrar o contador
        echo "<div class='price-tag'>$formattedPrice</div>"; // Mostrar o preço formatado
        echo "<img src='$imageUrl' alt='{$row['prod_name']}'>";
        echo "<div class='product-name'><h5>{$row['prod_name']}</h5></div>"; 
        //echo "<div class='product-brand'><h4>{$row['prod_brand']}</h4></div>"; 

        echo "<div class='dimensions-row'>";
            echo "<div class='dimensions-section'>";
                echo "<h6>CAT</h6>";
                displayDimension($row, 'D2', 'CPC');
                displayDimension($row, 'D3', 'CSC');
                displayDimension($row, 'D9', 'CPM');
            echo "</div>"; // Fechando CAT
            
            echo "<div class='dimensions-section'>";
                echo "<h6>BRAND</h6>";
                displayDimension($row, 'D1', 'MPC');
                displayDimension($row, 'D4', 'MUD');
                displayDimension($row, 'D5', 'MUPM');
            echo "</div>"; // Fechando BRAND
            
            echo "<div class='dimensions-section'>";
                echo "<h6>PRICE</h6>";
                displayDimension($row, 'D6', 'PPM');
                displayDimension($row, 'D7', 'PV');
                displayDimension($row, 'D8', 'PP');
            echo "</div>"; // Fechando PRICE
        echo "</div>"; // Fechando dimensions-row

        echo "<div class='dimensions-row'>";
            echo "<div class='dimensions-section'>"; //distancia
                echo "<h6>DIST</h6>";
                echo "<p>" . number_format($row['distance'], 2) . "</p>";
            echo "</div>";

            echo "<div class='dimensions-section'>"; //cluster
                echo "<h6>CLUST</h6>";
                displayCluster($row['Cluster']);
            echo "</div>";

            echo "<div class='dimensions-section'>"; // PC
                echo "<h6>PC</h6>";
                displayDimension($row, 'PC1', 'PC1');
                displayDimension($row, 'PC2', 'PC2');
                displayDimension($row, 'PC3', 'PC3');
            echo "</div>";
        echo "</div>"; // Fechando dimensions-row
    echo "</div>"; // Fechando product-item
    $counter++;
}

echo "</div>"; // Fechando product-grid





function getColorForDimension($value) {
    $red = (1 - $value) * 255;
    $green = $value * 255;
    $blue = 0;
    return sprintf("#%02x%02x%02x", $red, $green, $blue);
}

function getColorForPC($value) {
    if ($value < 0) {
        // Valores negativos vão de amarelo a branco
        $red = 255;
        $green = 255 - abs($value) * (255 / 3);
        $blue = 0;
    } else {
        // Valores positivos vão de branco a azul
        $red = 255 - $value * (255 / 3);
        $green = 255 - $value * (255 / 3);
        $blue = 255;
    }
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

function displayPC($value, $dim) {
    $color = getColorForPC(floatval($value));
    echo "<div class='tooltip'>";
    echo "<div class='dim-box' style='background-color: $color;'></div>";
    echo "<span class='tooltiptext'>$dim: " . number_format(floatval($value), 2) . "</span>";
    echo "</div>";
}

function displayCluster($clusterNumber) {
    // Definir uma paleta de cores para os clusters (0 a 4)
    $colors = ['#FF6347', '#4682B4', '#32CD32', '#FFD700', '#FF69B4']; // Exemplo de cores
    // Pegar a cor correspondente ao número do cluster
    $color = $colors[$clusterNumber];
    // Exibir o quadrado com o número do cluster centralizado
    echo "<div class='cluster-box' style='background-color: $color;'>";
    echo "<span>$clusterNumber</span>";
    echo "</div>";
}

?>