<?php
// count()
$arr = [1, 2, 3];
echo count($arr); // => 3
// array_merge()
$a = [1, 2];
$b = [3, 4];
$merged = array_merge($a, $b); // [1, 2, 3, 4]
// array_push()
$arr = [1, 2];
array_push($arr, 3, 4);
print_r($arr); // [1, 2, 3, 4]
// array_pop()
$arr = [1, 2, 3];
$last = array_pop($arr);
echo $last; // => 3
// array_shift()
$arr = [1, 2, 3];
$first = array_shift($arr);
echo $first; // => 1
// array_unshift()
$arr = [2, 3];
array_unshift($arr, 1);
print_r($arr); // [1, 2, 3]
// in_array()
$arr = ['apple', 'banana'];
echo in_array('banana', $arr); // => true (1)
// array_key_exists()
$arr = ['name' => 'Duy'];
echo array_key_exists('name', $arr); // => true (1)
// array_keys()
$arr = ['name' => 'Duy', 'age' => 20];
print_r(array_keys($arr)); // ['name', 'age']
// array_values()
$arr = ['name' => 'Duy', 'age' => 20];
print_r(array_values($arr)); // ['Duy', 20]
// array_filter()
$arr = [1, 2, 3, 4];
$even = array_filter($arr, function($val) {
    return $val % 2 == 0;
});
print_r($even); // [1 => 2, 3 => 4]
// array_map()
$ten = ['duy', 'tthe anh', 'tuan'];
$vietHoaTen = array_map('ucfirst', $ten);
print_r($vietHoaTen);
// sort()
$arr = [3, 1, 2];
sort($arr);
print_r($arr); // [1, 2, 3]
// array_unique()
$arr = [1, 2, 2, 3];
$unique = array_unique($arr);
print_r($unique); // [0 => 1, 1 => 2, 3 => 3]
// compact()
$name = "Duy";
$age = 21;
$data = compact("name", "age");
print_r($data); // ['name' => 'Duy', 'age' => 21]