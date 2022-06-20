    $(function() {
        $('a#list_ips').on('click', function(e){
            $.ajax({
                url: '',
                type: 'get',
                contentType: 'application/json',
                "id": "getIp",
                data: {
                    list_ips_txt: $(this).innerHTML,
                    test_text: "test"
                },
                success: function(response){
                    document.getElementById("ips").innerHTML = response.ip
                }
            })
            console.log("clicked")
            
        })
    });

   function addIP(){
    $.ajax({
        url: '',
        type: 'get',
        contentType: 'application/json',
        "id": "addIP",
        data: {
            ip: document.getElementById("ipAdr").innerText,
            riskN: document.getElementById("riskN").innerText,
            comments: document.getElementById("comment").innerText
        },
        success: function(response){
            document.getElementById("ips").innerHTML = "ip added"
        }
    })
   }