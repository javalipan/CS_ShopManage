package com.manage.query.model;

import com.manage.dao.model.Goods;
import com.manage.util.Pager;

public class GoodsQuery extends Goods{

	private static final long serialVersionUID = 1L;
	
	/**
	* @Fields brandname : 品牌名称
	*/
	private String brandname;
	/**
	 * @Fields typename : 分类名称
	 */
	private String typename;
	/**
	 * @Fields codelike : 编码模糊查询
	 */
	private String codelike;
	
	private String brandType;
	
	/**
	 *风格 
	 */
	private String styletypename;

	private Pager pager;
	private String orderBy;
	
	/**
	 * 累计库存量
	 */
	private int totalamount;
	/**
	 * 剩余库存总数量
	 */
	private int amount;
	/**
	 * 累计销量
	 */
	private int saleamount;
	/**
	 * 累计销售金额
	 */
	private double saleprice;
	

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

	public String getBrandname() {
		return brandname;
	}

	public void setBrandname(String brandname) {
		this.brandname = brandname;
	}

	public String getTypename() {
		return typename;
	}

	public void setTypename(String typename) {
		this.typename = typename;
	}

	public String getBrandType() {
		return brandType;
	}

	public void setBrandType(String brandType) {
		this.brandType = brandType;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public int getTotalamount() {
		return totalamount;
	}

	public void setTotalamount(int totalamount) {
		this.totalamount = totalamount;
	}

	public int getSaleamount() {
		return saleamount;
	}

	public void setSaleamount(int saleamount) {
		this.saleamount = saleamount;
	}

	public double getSaleprice() {
		return saleprice;
	}

	public void setSaleprice(double saleprice) {
		this.saleprice = saleprice;
	}

	public String getCodelike() {
		return codelike;
	}

	public void setCodelike(String codelike) {
		this.codelike = codelike;
	}

	public String getStyletypename() {
		return styletypename;
	}

	public void setStyletypename(String styletypename) {
		this.styletypename = styletypename;
	}
	
}
