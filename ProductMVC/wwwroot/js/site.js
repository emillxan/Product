$(document).ready(function () {
    const apiUrl = "https://localhost:7156/api/products"; 

    function loadProducts(search = "") {
        $.ajax({
            url: `${apiUrl}?name=${search}`, 
            method: 'GET',
            success: function (data) {
                let rows = '';
                data.forEach(product => {
                    rows += `<tr>
                        <td>${product.name}</td>
                        <td>${product.description}</td>
                        <td>
                            <button class="btn btn-warning btn-sm editProduct" data-id="${product.id}">Изменить</button>
                            <button class="btn btn-danger btn-sm deleteProduct" data-id="${product.id}">Удалить</button>
                        </td>
                    </tr>`;
                });
                $('#productTableBody').html(rows);
            },
            error: function () {
                alert('Ошибка при загрузке продуктов.');
            }
        });
    }

    $('#addProductBtn').on('click', function () {
        $('#productId').val('');
        $('#productName').val('');
        $('#productDescription').val('');
        $('#productModalLabel').text('Создать продукт');
    });

    $('#productForm').on('submit', function (event) {
        event.preventDefault();
        const id = $('#productId').val();
        const productAdd = {
            name: $('#productName').val(),
            description: $('#productDescription').val()
        };
        const productEdit = {
            id: $('#productId').val(),
            name: $('#productName').val(),
            description: $('#productDescription').val()
        };

        if (id) {
            $.ajax({
                url: `${apiUrl}/${id}`, 
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(productEdit),
                success: function () {
                    $('#productModal').modal('hide');
                    loadProducts();
                },
                error: function () {
                    alert('Ошибка при редактировании продукта.');
                }
            });
        } else {
            $.ajax({
                url: apiUrl, 
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(productAdd),
                success: function () {
                    $('#productModal').modal('hide');
                    loadProducts();
                },
                error: function () {
                    alert('Ошибка при создании продукта.');
                }
            });
        }
    });

    $(document).on('click', '.editProduct', function () {
        const id = $(this).data('id');
        $.ajax({
            url: `${apiUrl}/${id}`,
            method: 'GET',
            success: function (product) {
                $('#productId').val(product.id);
                $('#productName').val(product.name);
                $('#productDescription').val(product.description);
                $('#productModalLabel').text('Редактировать продукт');
                $('#productModal').modal('show');
            },
            error: function () {
                alert('Ошибка при получении данных продукта.');
            }
        });
    });

    $(document).on('click', '.deleteProduct', function () {
        const id = $(this).data('id');
        if (confirm('Вы уверены, что хотите удалить продукт?')) {
            $.ajax({
                url: `${apiUrl}/${id}`,
                method: 'DELETE',
                success: function () {
                    loadProducts();
                },
                error: function () {
                    alert('Ошибка при удалении продукта.');
                }
            });
        }
    });

    $('#searchBtn').on('click', function () {
        const search = $('#searchProduct').val();
        loadProducts(search);
    });

    loadProducts();
});
