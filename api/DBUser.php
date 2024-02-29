<?php
include_once 'DBService.php';

class DBUser {
    private $dbService;

    function __construct() {
        $this->dbService = new DBService();
    }

    public function verifyUser($login, $password) {
        $sql = "SELECT * FROM User WHERE user_login = ? AND user_password = ?";

        $user = $this->dbService->query($sql, [$login, $password]);

        return $user ? $user[0] : null;
    }

    public function getUsersByState($state) {
        $sql = "SELECT user_id, user_login FROM User WHERE user_uf = ?";
    
        return $this->dbService->query($sql, [$state]);
    }

    public function getUserProfile($userId) {
        $sql = "SELECT * FROM UserProfile_VW WHERE user_id = ?";

        $profile = $this->dbService->query($sql, [$userId]);

        return $profile ? $profile[0] : null;
    }

    public function getAllUserProfiles() {
        $sql = "SELECT * FROM UserProfile_VW";

        $profiles = $this->dbService->query($sql);

        return $profiles;
    }

    
}
?>
