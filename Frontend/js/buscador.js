const data = [
    "109283746",
    "Juan",
    "Estevan",
    "Raul",
    "David",
    "Carlos",
];

const searchInput = document.getElementById("search");
const resultsContainer = document.getElementById("results");

searchInput.addEventListener("input", () => {
    const searchTerm = searchInput.value.toLowerCase();

    // Filtrar resultados
    const filteredResults = data.filter(result => result.toLowerCase().includes(searchTerm));

    // Mostrar u ocultar resultados según la búsqueda
    if (searchTerm === "") {
        resultsContainer.style.display = "none";
    } else {
        resultsContainer.style.display = "block";
        displayResults(filteredResults);
    }
});

function displayResults(results) {
    resultsContainer.innerHTML = "";

    if (results.length === 0) {
        resultsContainer.innerHTML = "No se encontraron resultados.";
    } else {
        results.forEach(result => {
            const resultElement = document.createElement("div");
            resultElement.textContent = result;
            resultsContainer.appendChild(resultElement);
        });
    }
}
