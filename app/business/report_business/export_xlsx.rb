require 'write_xlsx'

module ReportBusiness
  class ExportXlsx
    def initialize(params)
      @blocks = params
    end

    def call
      run
    end

    private

    def run
      set_workbook
      set_styles
      set_column_widths
      write_blocks

      @workbook.close

      @tempfile
    end

    def set_column_widths
      initial_column = 0
      final_column = 9
      width = 20

      @worksheet.set_column(initial_column, final_column, width)
    end

    def set_workbook
      file_name = "relatorio_#{Time.now.strftime('%d-%m-%Y_%H-%M-%S')}"
      @tempfile = Tempfile.new([file_name, '.xlsx'])
      @workbook = WriteXLSX.new(@tempfile.path)
      @worksheet = @workbook.add_worksheet('Sheet 1')
    end

    def set_styles
      @header_format = @workbook.add_format(
        bold: true,
        align: 'center',
        valign: 'vcenter',
        bg_color: 'blue',
        color: 'white',
        border: 1
      )
      @default_format = @workbook.add_format(
        align: 'center',
        valign: 'vcenter'
      )
      @section_title_format = @workbook.add_format(
        bold: true,
        align: 'left',
        valign: 'vcenter',
        size: 16,
      )
      @jump_row = 2
    end

    def write_blocks
      @current_row = 0
      @blocks.each do |block|
        layout = block[:section_layout] || :detailed
        write_block(block, layout)
        @current_row += @jump_row
      end
    end

    def write_block(block, layout)
      write_section_title(block[:section_title])

      if layout == :detailed
        write_detailed_data(block[:data])
      else
        write_summary_data(block[:data])
      end
    end

    def write_section_title(title)
      @worksheet.merge_range(@current_row, 0, @current_row, 1, title, @section_title_format)
      @current_row += 1
    end

    # header na primeira coluna e valor na segunda coluna
    def write_detailed_data(data)
      data.each do |row|
        row.each do |col, val|
          @worksheet.write(@current_row, 0, col, @header_format)
          @worksheet.write(@current_row, 1, val, @default_format)
          @current_row += 1
        end
      end
    end

    # header na primeira linha e valores nas linhas seguintes
    def write_summary_data(data)
      headers = data.first.keys
      values = data.map(&:values)

      # Write headers
      @worksheet.write_row(@current_row, 0, headers, @header_format)
      @current_row += 1

      # Write values
      values.each do |row|
        @worksheet.write_row(@current_row, 0, row, @default_format)
        @current_row += 1
      end
    end
  end
end
