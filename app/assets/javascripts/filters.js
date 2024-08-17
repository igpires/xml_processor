document.addEventListener('DOMContentLoaded', function() {
    const entitySelect = document.getElementById('entity_select');
    const documentFilters = document.getElementById('document-filters');
    const productFilters = document.getElementById('product-filters');
    const searchField = document.getElementById('filter_query');
    const filterButton = document.querySelector('.btn-filter');

    // Esconde todos os filtros no início
    documentFilters.style.display = 'none';
    productFilters.style.display = 'none';

    // Mostra os filtros de acordo com a entidade selecionada
    entitySelect.addEventListener('change', function() {
        const selectedEntity = this.value;
        documentFilters.style.display = 'none';
        productFilters.style.display = 'none';

        if (selectedEntity === 'document') {
            documentFilters.style.display = 'block';
        } else if (selectedEntity === 'product') {
            productFilters.style.display = 'block';
        }

        // Limpa o campo de pesquisa e desativa a entrada
        searchField.value = '';
        searchField.disabled = true;
        searchField.removeAttribute('name');
    });


    function handleCheckboxChange(event) {
        const checkboxes = event.target.classList.contains('document-check') ? document.querySelectorAll('.document-check') : document.querySelectorAll('.product-check');

        checkboxes.forEach(cb => {
            if (cb !== event.target) {
                cb.checked = false;
            }
        });

        if (event.target.checked) {
            searchField.disabled = false;
            const filterName = event.target.getAttribute('name');
            const cleanedFilterName = filterName.replace(/^q\[(.+)\]$/, '$1');
            searchField.setAttribute('name', `q[${cleanedFilterName}]`);
            console.log("Campo de pesquisa ativado com nome:", searchField.getAttribute('name'));
        } else {
            searchField.disabled = true;
            searchField.removeAttribute('name');
        }
    }

    document.querySelectorAll('.document-check').forEach(cb => cb.addEventListener('change', handleCheckboxChange));
    document.querySelectorAll('.product-check').forEach(cb => cb.addEventListener('change', handleCheckboxChange));

    filterButton.addEventListener('click', function(event) {
        event.preventDefault();

        const activeFieldName = searchField.getAttribute('name');
        const activeFieldValue = searchField.value.trim();

        const relevantParams = {};
        if (activeFieldName && activeFieldValue) {
            relevantParams[activeFieldName] = activeFieldValue;
        }

        const queryString = new URLSearchParams(relevantParams).toString();
        const actionUrl = '/documents?' + queryString;

        if (queryString) {
            window.location.href = actionUrl;
            console.log("Redirecionando para:", actionUrl);
        } else {
            console.log("Nenhum parâmetro relevante foi encontrado para enviar.");
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const toggleButton = document.getElementById('toggle-filter-bar-button');
    const filterBar = document.getElementById('filter-bar');
  
    // Verifica o estado armazenado em localStorage
    const isFilterBarOpen = localStorage.getItem('filterBarOpen') === 'true';
  
    if (isFilterBarOpen) {
      filterBar.style.display = 'flex';
      toggleButton.textContent = 'Esconder Filtros';
    } else {
      filterBar.style.display = 'none';
      toggleButton.textContent = 'Mostrar Filtros';
    }
  
    toggleButton.addEventListener('click', function() {
      if (filterBar.style.display === 'none' || filterBar.style.display === '') {
        filterBar.style.display = 'flex'; // Exibe a barra de filtros
        toggleButton.textContent = 'Esconder Filtros';
        localStorage.setItem('filterBarOpen', 'true'); // Armazena o estado
      } else {
        filterBar.style.display = 'none'; // Oculta a barra de filtros
        toggleButton.textContent = 'Mostrar Filtros';
        localStorage.setItem('filterBarOpen', 'false'); // Armazena o estado
      }
    });
  
    // Reseta o estado quando o botão "Limpar Filtros" é clicado
    const resetButton = document.querySelector('.btn-reset-filters');
    if (resetButton) {
      resetButton.addEventListener('click', function() {
        localStorage.setItem('filterBarOpen', 'false');
      });
    }
  });
  