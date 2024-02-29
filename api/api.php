<?php
function readCategoriesFromCSV($filename) {
    $categories = [];
    if (($handle = fopen($filename, "r")) !== FALSE) {
        fgetcsv($handle, 1000, ";"); // Ignorar a linha de cabeçalho
        while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
            $emoji = $data[14]; // Coluna 'O' (emj2)
            $category = $data[10]; // Coluna 'K' (cat2)
            $color = $data[7]; // Coluna 'H' (cor1)
            $categories[] = ['emoji' => $emoji, 'category' => $category, 'color' => $color];
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
    $generateJSON = isset($_POST['generateJSON']);

    // Aqui, você deve processar os dados e chamar a API search_v3.php conforme necessário.
    // O processamento e a lógica de chamada da API serão detalhados posteriormente.
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>HiperHyped API</title>
    <style>
        /* Aqui, você pode adicionar estilos CSS para a barra superior e outros elementos */
        .top-bar {
            height: 100px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            padding: 0 20px;
        }
        /* Estilizações adicionais aqui */
    </style>
</head>
<body>
    <div class="top-bar">
        <img src="logo_hiperhyped.png" alt="Logo HiperHyped" style="height: 90px;"> <!-- Substitua pelo caminho correto do logo -->
        <form method="post" style="flex-grow: 1; display: flex; align-items: center; justify-content: space-between;">
            <select name="searchType">
                <?php foreach ($searchTypes as $type): ?>
                    <option value="<?= $type ?>"><?= ucfirst($type) ?></option>
                <?php endforeach; ?>
            </select>
            <input type="text" name="searchValue" placeholder="Digite aqui...">
            <select name="categoryId">
                <?php foreach ($categories as $category): ?>
                    <option value="<?= $category['category'] ?>" style="color: <?= $category['color'] ?>;"><?= $category['emoji'] . ' ' . $category['category'] ?></option>
                <?php endforeach; ?>
            </select>
            <label>
                Gerar JSON?
                <input type="checkbox" name="generateJSON">
            </label>
            <button type="submit">Confirmar</button>
        </form>
    </div>

    <!-- Aqui, você pode adicionar a parte principal da página, incluindo a exibição dos resultados da API -->
    <!-- Resultados da API serão exibidos aqui -->

</body>
</html>
