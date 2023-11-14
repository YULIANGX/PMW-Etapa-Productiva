const loginForm = document.getElementById("login-form");

loginForm.addEventListener("submit", function (e) {
    e.preventDefault();

    // Obtener los valores del nombre de usuario y contraseña
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    // Verificar si los datos son correctos (esto es solo un ejemplo, debes usar una lógica más segura en un entorno real)
    if (username === "admin" && password === "12345") {
        // Los datos son correctos, redirigir a la página siguiente
        window.location.href = "index.html";
    } else {
        alert("Nombre de usuario o contraseña incorrectos. Inténtalo de nuevo.");
    }
});
