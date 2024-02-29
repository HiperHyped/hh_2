<?php
include_once 'DBService.php';

class DBGrid {
    private $dbService;

    function __construct() {
        $this->dbService = new DBService();
    }

    public function getProductsForGridV3($sigla, $gridLimit, $userId) {
        $sql = "CALL GetClosestProductsAndPriceByUserAndCategory(?, ?, ?)";
        $arguments = [$sigla, $gridLimit, $userId];
        $results = $this->dbService->query($sql, $arguments);

        $productList = [];
        foreach ($results as $row) {
            $eanModel = [
                'ean' => $row['prod_ean'],
                'nome' => $row['prod_name'],
                'imagem' => $row['prod_image'],
                'marca' => $row['prod_brand'],
                'unidade' => $row['prod_unit'],
                'volume' => $row['prod_vol'],
                'w1' => $row['prod_word1'],
                'w2' => $row['prod_word2'],
                'w3' => $row['prod_word3'],
                'w4' => $row['prod_word4'],
                'sigla' => $row['sigla'],
                'sig3' => $row['sig3'],
                'preco' => $row['prod_price'],
                'link' => '', // Assumindo que 'link' é preenchido em outro lugar
                'hintStatus' => $row['hint_status']
                // 'searchType' é omitido pois não consta no modelo EanModel
            ];
            array_push($productList, $eanModel);
        }

        // A chamada para 'CalculateUserProfileForSpecificUser' será feita no grid.php
        return $productList;
    }
}
?>
