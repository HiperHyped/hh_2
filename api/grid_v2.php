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
echo "  .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px; }";
echo "  .product-item { border: 1px solid #ddd; padding: 0px; text-align: center; }";
echo "  .product-item img { max-width: 100%; height: 150px; object-fit: cover; }"; // altura fixa e redimensionamento da imagem
echo "  .dim-box { width: 15px; height: 15px; margin: 1px; }";
echo "  .tooltip { position: relative; display: inline-block; }";
echo "  .product-name, .product-brand { height: 60px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }"; // limita a duas linhas
echo "  .tooltip .tooltiptext { visibility: hidden; width: 120px; background-color: black; color: #fff; text-align: center;";
echo "      border-radius: 6px; padding: 0px 0; position: absolute; z-index: 1; bottom: 125%; left: 50%; margin-left: -60px;";
echo "      opacity: 0; transition: opacity 0.3s; }";
echo "  .tooltip:hover .tooltiptext { visibility: visible; opacity: 1; }";
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
    echo "<div class='product-name'><h5>{$row['prod_name']}</h5></div>"; // altura fixa para o nome
    echo "<div class='product-brand'><h4>{$row['prod_brand']}</h4></div>"; // altura fixa para a marca
    echo "<h6>Preço: {$row['prod_price']}</h6>";
    echo "<div style='display: flex; justify-content: center;'>";

    for ($i = 1; $i <= 9; $i++) {
        $dimValue = floatval($row["D$i"]);
        $color = getColorForDimension($dimValue);
        echo "<div class='tooltip'>";
        echo "<div class='dim-box' style='background-color: $color;'></div>";
        echo "<span class='tooltiptext'>D$i: " . number_format($dimValue, 2) . "</span>";
        echo "</div>";
    }

    echo "</div>";
    echo "</div>";
}

echo "</div>";
?>
