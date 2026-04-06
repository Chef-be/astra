(function(window, document) {
  'use strict';

  function uploadEditorImage(file) {
    var formData = new FormData();
    formData.append('file', file, file.name || 'image');

    return fetch('editor-upload.php', {
      method: 'POST',
      body: formData,
      credentials: 'same-origin',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    }).then(function(response) {
      return response.json().then(function(payload) {
        if (!response.ok || !payload.location) {
          throw new Error(payload.message || 'Le téléversement de l’image a échoué.');
        }

        return payload.location;
      });
    });
  }

  function initRichEditors() {
    if (typeof tinymce === 'undefined') {
      return;
    }

    if (tinymce.editors && tinymce.editors.length) {
      tinymce.editors.forEach(function(editor) {
        editor.remove();
      });
    }

    tinymce.init({
      selector: 'textarea.rich-editor',
      menubar: false,
      branding: false,
      promotion: false,
      convert_urls: false,
      relative_urls: false,
      remove_script_host: false,
      automatic_uploads: true,
      images_upload_credentials: true,
      paste_data_images: false,
      file_picker_types: 'image',
      min_height: 320,
      skin: 'oxide-dark',
      content_css: 'dark',
      plugins: 'advlist autolink lists link image charmap preview anchor searchreplace visualblocks code fullscreen insertdatetime media table wordcount help autoresize',
      toolbar: 'undo redo | blocks | bold italic underline strikethrough | forecolor backcolor | bullist numlist blockquote table | alignleft aligncenter alignright alignjustify | link image media | removeformat code fullscreen preview',
      toolbar_mode: 'sliding',
      content_style: 'body { background:#0b1120; color:#e5eef8; font-family: Inter, Segoe UI, Arial, sans-serif; font-size:14px; } a { color:#7dd3fc; } img { max-width:100%; height:auto; border-radius:12px; }',
      images_upload_handler: function(blobInfo) {
        return uploadEditorImage(blobInfo.blob());
      },
      file_picker_callback: function(callback, value, meta) {
        if (meta.filetype !== 'image') {
          return;
        }

        var input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/png,image/jpeg,image/gif,image/webp';
        input.addEventListener('change', function() {
          if (!input.files || !input.files[0]) {
            return;
          }

          uploadEditorImage(input.files[0]).then(function(url) {
            callback(url, { alt: input.files[0].name });
          }).catch(function(error) {
            tinymce.activeEditor.windowManager.alert(error.message || 'Le téléversement de l’image a échoué.');
          });
        });
        input.click();
      },
      setup: function(editor) {
        editor.on('init', function() {
          var iframe = editor.getContainer();
          if (iframe) {
            iframe.classList.add('astra-rich-editor-ready');
          }
        });
      }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initRichEditors);
  } else {
    initRichEditors();
  }
})(window, document);
