<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE'); 
header('Access-Control-Allow-Headers: Content-Type'); 


$servername = "fdb1029.awardspace.net"; 
$username = "4569575_waelawadaproject";   
$password = "Test1234";   
$dbname = "4569575_waelawadaproject"; 


$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT id, full_name, class, grade FROM students";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $students = [];

    while($row = $result->fetch_assoc()) {
        $students[] = $row;
    }

    echo json_encode([
        // "data" => 'hello',
        "data" => $students,
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No students found"
    ]);
}

$conn->close();
?>

