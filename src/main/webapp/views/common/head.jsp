<%@page contentType="text/html" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath()%>/assets/img/logo.jpg">
<link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/main.css">
<link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/header.css">
<link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/home.css">
<link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/search.css">
<link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/nutrition.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/datatables/1.10.21/css/dataTables.bootstrap.min.css" integrity="sha512-BMbq2It2D3J17/C7aRklzOODG1IQ3+MHw3ifzBHMBwGO/0yUqYmsStgBjI0z5EYlaDEFnvYV7gNYdD3vFLRKsA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const avatar = document.getElementById('avatarIcon');
    const dropdown = document.getElementById('userDropdown');

    if (avatar) {
      avatar.addEventListener('click', function () {
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
      });

      // Ẩn dropdown khi click ngoài
      document.addEventListener('click', function (e) {
        if (!avatar.contains(e.target) && !dropdown.contains(e.target)) {
          dropdown.style.display = 'none';
        }
      });
    }
  });
</script>