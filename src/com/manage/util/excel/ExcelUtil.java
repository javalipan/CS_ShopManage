package com.manage.util.excel;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;

public class ExcelUtil {

	public static void exportLabelExcel(HttpServletResponse response,JSONArray data) throws IOException {
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("标签打印表");
		HSSFRow titleRow = sheet.createRow(0);
		HSSFCell hcell0=titleRow.createCell(0);
		formatHeaderCellStyle(wb, hcell0);
		hcell0.setCellValue("商品编码");
		HSSFCell hcell1=titleRow.createCell(1);
		formatHeaderCellStyle(wb, hcell1);
		hcell1.setCellValue("商品名称");
		HSSFCell hcell2=titleRow.createCell(2);
		formatHeaderCellStyle(wb, hcell2);
		hcell2.setCellValue("单位");
		HSSFCell hcell22=titleRow.createCell(3);
		formatHeaderCellStyle(wb, hcell22);
		hcell22.setCellValue("季节");
		HSSFCell hcell3=titleRow.createCell(4);
		formatHeaderCellStyle(wb, hcell3);
		hcell3.setCellValue("主要材质");
		HSSFCell hcell4=titleRow.createCell(5);
		formatHeaderCellStyle(wb, hcell4);
		hcell4.setCellValue("执行标准");
		HSSFCell hcell5=titleRow.createCell(6);
		formatHeaderCellStyle(wb, hcell5);
		hcell5.setCellValue("颜色");
		HSSFCell hcell6=titleRow.createCell(7);
		formatHeaderCellStyle(wb, hcell6);
		hcell6.setCellValue("尺码大小");
		HSSFCell hcell7=titleRow.createCell(8);
		formatHeaderCellStyle(wb, hcell7);
		hcell7.setCellValue("吊牌价");
		HSSFCell hcell8=titleRow.createCell(9);
		formatHeaderCellStyle(wb, hcell8);
		hcell8.setCellValue("条码");
		HSSFCell hcell9=titleRow.createCell(10);
		formatHeaderCellStyle(wb, hcell9);
		hcell9.setCellValue("库存数量");
		for(int i=0;i<data.size();i++){
			JSONObject obj=data.getJSONObject(i);
			HSSFRow row = sheet.createRow(i+1);
			HSSFCell cell0=row.createCell(0);
			formatCellStyle(wb, cell0);
			cell0.setCellValue(obj.getString("code"));
			HSSFCell cell1=row.createCell(1);
			formatCellStyle(wb, cell1);
			cell1.setCellValue(obj.getString("name"));
			HSSFCell cell11=row.createCell(2);
			formatCellStyle(wb, cell11);
			cell11.setCellValue(obj.getString("season"));
			HSSFCell cell2=row.createCell(3);
			formatCellStyle(wb, cell2);
			cell2.setCellValue(obj.getString("unit"));
			HSSFCell cell3=row.createCell(4);
			formatCellStyle(wb, cell3);
			cell3.setCellValue(obj.getString("material"));
			HSSFCell cell4=row.createCell(5);
			formatCellStyle(wb, cell4);
			cell4.setCellValue(obj.getString("standard"));
			HSSFCell cell5=row.createCell(6);
			formatCellStyle(wb, cell5);
			cell5.setCellValue(obj.getString("color"));
			HSSFCell cell6=row.createCell(7);
			formatCellStyle(wb, cell6);
			cell6.setCellValue(obj.getString("size"));
			HSSFCell cell7=row.createCell(8);
			formatCellStyle(wb, cell7);
			cell7.setCellValue(obj.getString("price"));
			HSSFCell cell8=row.createCell(9);
			formatCellStyle(wb, cell8);
			cell8.setCellValue(obj.getString("detailcode"));
			HSSFCell cell9=row.createCell(10);
			formatCellStyle(wb, cell9);
			cell9.setCellValue(obj.getString("num"));
		}

		OutputStream output=response.getOutputStream();
		response.reset();
		response.setHeader("Content-disposition","attachment; filename=data.xls");
		response.setContentType("application/msexcel");
		wb.write(output);
		output.close();
	}
	
	
	public static void formatHeaderCellStyle(HSSFWorkbook wb,HSSFCell cell){
		HSSFCellStyle cellStyle = wb.createCellStyle();
		cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		cellStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
		cell.setCellStyle(cellStyle);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
	}
	
	public static void formatCellStyle(HSSFWorkbook wb,HSSFCell cell){
		HSSFCellStyle cellStyle = wb.createCellStyle();
		cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		cell.setCellStyle(cellStyle);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
	}
}
