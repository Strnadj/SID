<html>
<head>
<title>Test</title>
</head>
<body>
<a href="nezabezpeceny.php?stranka=franta&amp;podstranka=nevim">Nezabezpeceny</a>
<a href="bezpecny.php?stranka=frantisek&podstranka=dalsi">Zabezpeceny</a>
<a href="polobezpecny.php?strankabezpecna=franta&amp;strankanebezpecna=nevim">Polobezpecny</a>

<form action="login.php" method="get">
    <input type="text" name="jmeno" />
    <input type="password" name="heslo" />
    <input type="submit" value="Login"
</form>

<form action="login2.php" method="post">
    <input type="text" name="jmeno" />
    <input type="password" name="heslo" />
    <input type="submit" value="Login"
</form>

</body>
