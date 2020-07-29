<?php
    $host = "localhost";
    $database = "id13800883_projet";
    $user = "id13800883_jores";
    $pass = "k*6sx&X6&s-bL=$1";
    try {
        $db = new PDO("mysql:host=".$host.";dbname=".$database, $user, $pass);
    } catch (Exception $e) {
        echo $e->getMessage();
    }

    $user = $_POST['user'];
    $age = $_POST['age'];
     $email = $_POST['email'];
    $pass = $_POST['pass'];
    $type = (int)$_POST['type'];

    if($type == 1){
        try {
            $query = $db->prepare("SELECT * FROM users where nom=?");
            $query->execute(array($user));
            $exist = $query->rowCount();

            if ($exist == 0) {
                $pass = sha1($pass);
                $query = $db->prepare("INSERT INTO users(nom, age, email, pass) VALUES(?,?,?,?)");
                $query->execute(array($user, $age, $email,$pass));
                $msg['statut'] = "Utilisateur enregistrer avec succès";
                $msg['val'] = 1;
            } else {
                $msg['statut'] = "Non d'utilisateur déjà attibuer";
                $msg['val'] = 0;
            }
        } catch (Exception $e) {
        }
    }
    else{
        try {
        $pass = sha1($pass);

            $query = $db->prepare("SELECT * FROM users where nom=? AND pass=?");
            $query->execute(array($user, $pass));
            $exist = $query->rowCount();
            if ($exist == 1) {
                $info = $query->fetch();
                $msg['statut'] = "Utilisateur connecté avec succès";
                $msg['val'] = 1;
                $msg['info'] = [
                    "nom"=>$info['nom'],
                    "age"=> $info['age'],
                    "email"=> $info['email']
                ];
            } else {
                $msg['statut'] = "Non d'utilisateur ou mot de passe incorrect";
                $msg['val'] = 0;
                $msg['user'] = "user: $user, pass: $pass";
            }
        } catch (Exception $e) {
        }
    }

    echo json_encode($msg);
?>