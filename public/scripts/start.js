document.addEventListener('DOMContentLoaded', function() {
  const textos = ["LENCERIA", "ROPA DEPORTIVA"];
  const imagenes = ["/front/banner1.jpeg", "/front/banner2.jpeg"];

  let index = 0;

  function cambiarContenido() {
    const texto = document.getElementById('texto1');
    texto.style.opacity = '0'; // Hacer que el texto desaparezca suavemente
    setTimeout(() => {
      texto.textContent = textos[index];
      texto.style.opacity = '1'; // Hacer que el nuevo texto aparezca suavemente
      document.querySelector('.banner').style.backgroundImage = `linear-gradient(100deg, #000000c8, #00000000), url('${imagenes[index]}')`;
      index = (index + 1) % textos.length;
    }, 500); // Un pequeño retraso para permitir que la transición de opacidad ocurra antes de cambiar el texto
  }

  setInterval(cambiarContenido, 5000); // Cambiar contenido cada 10 segundos
});

