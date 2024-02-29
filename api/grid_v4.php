<?php
include_once 'DBSearch.php';

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
$searchType = 'category';
$categoryId = $data['categoryId'] ?? '';
$inputLimit = $data['inputLimit'] ?? 10;

$searchProduct = [
    'userId' => $data['userId'] ?? '',
    'searchType' => $searchType,
    'sigla' => $categoryId
];

$dbSearch = new DBSearch();
$result = $dbSearch->searchProductV2($searchProduct, $inputLimit);

function getColorForDimension($value) {
    $red = (1 - $value) * 255;
    $green = $value * 255;
    $blue = 0;
    return sprintf("#%02x%02x%02x", $red, $green, $blue);
}

echo "<style>";
echo "  .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 1px; }";
echo "  .product-item { border: 1px solid #ddd; padding: 0px; text-align: center; }";
echo "  .product-item img { max-width: 100%; height: auto; object-fit: cover; }";
echo "  .dim-box { width: 12px; height: 12px; margin: 1px; }";
echo "  .tooltip { position: relative; display: inline-block; }";
echo "  .product-name, .product-brand, .product-price { margin-bottom: 4px; }";
echo "  .dimensions-section, .additional-info { display: inline-block; vertical-align: top; }";
echo "  .additional-info { font-size: 0.75rem; }";
echo "  .tooltip .tooltiptext { visibility: hidden; width: 120px; background-color: black; color: #fff; text-align: center;";
echo "      border-radius: 6px; padding: 0px 0; position: absolute; z-index: 1; bottom: 125%; left: 50%; margin-left: -60px;";
echo "      opacity: 0; transition: opacity 0.3s; }";
echo "  .tooltip:hover .tooltiptext { visibility: visible; opacity: 1; }";
echo "  .dimensions-row { display: flex; justify-content: center; align-items: center; }";
echo "  .dimensions-section:not(:last-child) { border-right: 1px solid #ddd; padding-right: 0px; }";
echo "  .dimensions-section { margin-right: 0px; }";
echo "</style>";

echo "<div class='product-grid'>";

foreach ($result as $row) {
    $imageUrl = "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/" .
                substr($row['sigla'], 0, 1) . "/" .
                substr($row['sigla'], 1, 2) . "/" .
                substr($row['sigla'], 3) . "/" .
                $row['prod_image'];

    echo "<div class='product-item'>";
    echo "<img src='$imageUrl' alt='{$row['prod_name']}'>";
    echo "<div class='product-name'><h5>{$row['prod_name']}</h5></div>";
    echo "<div class='product-brand'><h4>{$row['prod_brand']}</h4></div>";
    echo "<div class='product-price'><h6>Preço: {$row['prod_price']}</h6></div>";

    echo "<div class='dimensions-row'>";
    echo "<div class='dimensions-section'>";
    echo "<h7>CAT</h7>";
    displayDimension($row, 'D2', 'CPC');
    displayDimension($row, 'D3', 'SPC');
    displayDimension($row, 'D9', 'CPM');
    echo "</div>"; // Fechando CAT
    
    echo "<div class='dimensions-section'>";
    echo "<h7>BRAND</h7>";
    displayDimension($row, 'D1', 'MPC');
    displayDimension($row, 'D4', 'MUD');
    displayDimension($row, 'D5', 'MUPM');
    echo "</div>"; // Fechando BRAND
    
    echo "<div class='dimensions-section'>";
    echo "<h7>PRICE</h7>";
    displayDimension($row, 'D6', 'PPM');
    displayDimension($row, 'D7', 'PV');
    displayDimension($row, 'D8', 'PP');
    echo "</div>"; // Fechando PRICE
    echo "</div>"; // Fechando dimensions-row

    // Informações adicionais abaixo das dimensões
    echo "<div class='additional-info'>";
    echo "<p>Distância: " . number_format($row['distance'], 1) . "</p>";
    echo "<p>Cluster: <span class='cluster-box' style='background-color: " . getClusterColor($row['Cluster']) . ";'>{$row['Cluster']}</span></p>";
    for ($i = 1; $i <= 3; $i++) {
        $pcValue = floatval($row["PC$i"]);
        $color = getPCColor($pcValue);
        echo "<div class='tooltip pc-box' style='background-color: $color;'>PC$i</div>";
        echo "<span class='tooltiptext'>PC$i: " . number_format($pcValue, 1) . "</span>";
    }
    echo "</div>"; // Fechando additional-info
    echo "</div>"; // Fechando product-item
}

echo "</div>"; // Fechando product-grid

function displayDimension($row, $dim, $sigla) {
    $dimValue = floatval($row[$dim]);
    $color = getColorForDimension($dimValue);
    echo "<div class='tooltip'>";
    echo "<div class='dim-box' style='background-color: $color;'></div>";
    echo "<span class='tooltiptext'>$sigla: " . number_format($dimValue, 2) . "</span>";
    echo "</div>";
}

function getClusterColor($cluster) {
    // Esta função deve retornar a cor correspondente ao cluster (0 - 4)
    // Exemplo de implementação simples, substitua com a lógica adequada para a paleta de cores
    $colors = ['#FFFF00', '#FFAA00', '#FF5500', '#FF0000', '#AA0000'];
    return $colors[$cluster] ?? '#FFFFFF';
}

function getPCColor($pcValue) {
    // Esta função deve retornar amarelo para -2 e azul para 2, com degradê para valores intermediários
    // Exemplo de implementação simples, substitua com a lógica adequada para o degradê de cores
    if ($pcValue <= -2) return '#FFFF00';
    if ($pcValue >= 2) return '#0000FF';
    // Cálculo de degradê
    $red = max(0, 255 - ($pcValue + 2) * 255 / 4);
    $green = max(0, 255 - abs($pcValue) * 255 / 2);
    $blue = max(0, 255 - ($pcValue - 2) * 255 / 4);
    return sprintf("#%02x%02x%02x", $red, $green, $blue);
}
?>
