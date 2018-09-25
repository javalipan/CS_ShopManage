package com.manage.query.model;

import com.manage.dao.model.Repertory;
import com.manage.util.Pager;

public class RepertoryQuery extends Repertory {

	private static final long serialVersionUID = 1L;
	
	private String code;
	private String detailcode;
	private String brandName;
	private String goodsName;
	private String colorName;
	private String sizeName;
	private String brandid;
	private Long goodsid;
	
	private Pager pager;
	private String orderBy;

	public Pager getPager() {
		return pager;
	}

	public void setPager(Pager pager) {
		this.pager = pager;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDetailcode() {
		return detailcode;
	}

	public void setDetailcode(String detailcode) {
		this.detailcode = detailcode;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getColorName() {
		return colorName;
	}

	public void setColorName(String colorName) {
		this.colorName = colorName;
	}

	public String getSizeName() {
		return sizeName;
	}

	public void setSizeName(String sizeName) {
		this.sizeName = sizeName;
	}

	public String getBrandid() {
		return brandid;
	}

	public void setBrandid(String brandid) {
		this.brandid = brandid;
	}

	public Long getGoodsid() {
		return goodsid;
	}

	public void setGoodsid(Long goodsid) {
		this.goodsid = goodsid;
	}
	
}
