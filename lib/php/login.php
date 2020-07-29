<?php
    $user = $_POST["user"];
    $pass = $_POST["pass"];

    $msg['msg'] = "Nom d'utilisateur: ".$user."  pass: ".$pass;
    echo json_encode($msg);
?>