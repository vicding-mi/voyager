const url = "https://script.google.com/macros/s/AKfycbyiGeNMA0XQFqUo3RW1BECtsUeuQ-p6HPsrDKOBTFj7GnSY_d8KfjUerGiPdeTrpqgL/exec"
window.onload = (event) => {
    fetch(url,
        {
            method: 'GET',
            headers: {
                'Content-Type': 'text/plain;charset=utf-8',
            }
        }
    ).then(function(response) {
        return response.json();
    }).then(function(data) {
        let procIdx = 1;
        let stepDiv = document.createElement("div");

        data.forEach((obj, idx) => {console.log(obj);
            const stepIdx = parseInt(obj.step);
            if(stepIdx > procIdx) {
                document.body.appendChild(stepDiv);
                divList.push(stepDiv);
                stepDiv = document.createElement("div");
                procIdx = stepIdx;
            }

            let div = document.createElement("div");
            if(obj.type.startsWith("Snippet")) {
                div.classList.add("text-wrapper");
                div.innerHTML += obj.content;
            }
            else if(obj.type.startsWith("Article")) {
                let innerDiv = document.createElement("div");

                innerDiv.classList.add("article-wrapper");
                innerDiv.innerHTML += obj.content;
                div.classList.add("article-bg");
                div.appendChild(innerDiv);
            }

            const stepCount = divList.length;
            if(obj.type.includes("Opaque")) {
                stepDiv.classList.add("opaque");
                div.classList.add("opaque");
            }
            else if(stepCount > 0 && divList[stepCount-1].classList.contains("opaque")) {
                stepDiv.classList.add("transition-in");
            }

            stepDiv.appendChild(div);

            //document.getElementsByClassName('text-wrapper')[idx].innerHTML += obj.content;
        });

        document.body.appendChild(stepDiv);
        divList.push(stepDiv);
    }).catch(function() {
        console.log("Google App Script Fail");
    });
}
