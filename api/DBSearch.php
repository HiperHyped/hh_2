<?php
include_once 'DBService.php';

class DBSearch {
    private $dbService;

    function __construct() {
        $this->dbService = new DBService();
    }

    public function searchProductV2($searchProduct, $inputLimit) {
        $searchType = $searchProduct['searchType'];
        $criteriaValue = "";
        $secondaryValue = "";
    
        switch ($searchType) {
            case 'ean':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'product':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'category':
                $criteriaValue = $searchProduct['sigla']; // Usando categoryId para pesquisa por categoria
                break;
            case 'brand':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'word':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'prod_cat':
                $criteriaValue = $searchProduct['searchValue'];
                $secondaryValue = $searchProduct['sigla'];
                break;
            default:
                throw new Exception("Tipo de pesquisa inválido: " . $searchType);
        }
    
        $sql = "CALL GetClosestProductsByCriteriaV2(?, ?, ?, ?, ?)";
        $arguments = [$searchProduct['userId'], $searchType, $criteriaValue, $secondaryValue, $inputLimit];
    
        return $this->dbService->query($sql, $arguments);
    }


    public function searchProductByDimensions($searchProduct, $inputLimit, $dimensions) {
        $searchType = $searchProduct['searchType'];
        $criteriaValue = "";
        $secondaryValue = "";
    
        switch ($searchType) {
            case 'ean':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'product':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'category':
                $criteriaValue = $searchProduct['sigla']; // Usando categoryId para pesquisa por categoria
                break;
            case 'brand':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'word':
                $criteriaValue = $searchProduct['searchValue'];
                break;
            case 'prod_cat':
                $criteriaValue = $searchProduct['searchValue'];
                $secondaryValue = $searchProduct['sigla'];
                break;
            default:
                throw new Exception("Tipo de pesquisa inválido: " . $searchType);
        }
    
        // Verifica se todas as 9 dimensões foram fornecidas
        if (count($dimensions) != 9) {
            throw new Exception("Número inválido de dimensões fornecidas");
        }
    
        // Preparando a chamada para a procedure GetClosestCriteriasByDimensions
        $sql = "CALL GetClosestCriteriasByDimensions(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        //$arguments = array_merge([$searchType, $criteriaValue, $secondaryValue, $inputLimit], $dimensions);
        $arguments = [
            $searchProduct['searchType'],
            $searchProduct['searchValue'],
            $searchProduct['sigla'], // Ou outra variável relevante para 'secondaryValue'
            $inputLimit,
            $dimensions['D1'],
            $dimensions['D2'],
            $dimensions['D3'],
            $dimensions['D4'],
            $dimensions['D5'],
            $dimensions['D6'],
            $dimensions['D7'],
            $dimensions['D8'],
            $dimensions['D9']
        ];
    
        return $this->dbService->query($sql, $arguments);
    }
    
    
}
?>

