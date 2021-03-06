const onTouchMove = (event) => {
  const container = document.querySelector('#touch').parentElement
  const windowHeight = window.innerHeight
  const y = event.touches[0].clientY
  const newTop = 100 * y / windowHeight
  const top = newTop > 88? 87: newTop < 0? 1 : newTop
  container.style.top = top + "vh"
  console.log(top, container.style.top)
  }

const onTouchStart = (event) => {
  document.addEventListener("touchmove", onTouchMove)
}

const onTouchEnd = (event) => {
  document.removeEventListener("touchmove", onTouchMove)
}

const initTouchIndex = () => {
  const touchButton = document.querySelector('#touch')
  if (touchButton) {
    touchButton.addEventListener("touchstart", onTouchStart)
    touchButton.addEventListener("touchend", onTouchEnd)
  }
}

export{initTouchIndex}
