document.querySelectorAll(".cli-button").forEach(btn => btn.addEventListener("click", () => {
    document.querySelector(".cli-terminal").innerHTML = btn.dataset.command
    document.querySelectorAll(".cli-button").forEach(btn => btn.classList.remove("active"))
    btn.classList.add("active")
}))

document.querySelector("#time").innerHTML = `Since request to render website was: ${Date.now() - parseInt(window._startTime)}ms`