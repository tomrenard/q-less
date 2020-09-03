const initToggleFavorite = () => {
  const favLink = document.querySelector("#favorite_link")
  if (favLink) {
    favLink.addEventListener('click', (event) => {
      if (favLink.innerHTML === 'Save it') {
        favLink.innerHTML = 'Unsave'
      } else {
        favLink.innerHTML = 'Save it'
      }
    })
  }
}

export { initToggleFavorite };
