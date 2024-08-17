document.addEventListener("DOMContentLoaded", function() {
    const fileTypeSelect = document.getElementById("file_type_select");
    const xmlUploadField = document.getElementById("xml_upload_field");
    const zipUploadField = document.getElementById("zip_upload_field");

    xmlUploadField.style.display = "none";
    zipUploadField.style.display = "none";

    fileTypeSelect.addEventListener("change", function() {

      xmlUploadField.style.display = "none";
      zipUploadField.style.display = "none";

      if (fileTypeSelect.value === 'xml') {
        xmlUploadField.style.display = "block";
      } else if (fileTypeSelect.value === 'zip') {
        zipUploadField.style.display = "block";
      }
    });
  });
