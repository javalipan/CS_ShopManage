package com.manage.action.platform;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Member;
import com.manage.dao.model.Order;
import com.manage.dao.model.OrderDetail;
import com.manage.dao.model.OrderDetailExample;
import com.manage.dao.model.OrderExample;
import com.manage.dao.model.PointLog;
import com.manage.dao.model.PointLogExample;
import com.manage.query.model.OrderDetailQuery;
import com.manage.query.model.OrderQuery;
import com.manage.service.IMemberService;
import com.manage.service.IOrderDetailService;
import com.manage.service.IOrderService;
import com.manage.service.IPointLogService;
import com.manage.util.ArrayUtil;
import com.manage.util.NumberUtil;
import com.manage.util.Pager;
import com.manage.util.weixin.TemplateMsgUtil;
import com.manage.util.weixin.WeixinUtils;

/**
 * 订单管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/order")
public class OrderController extends BaseController{
	
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IOrderDetailService orderDetailService;
	@Autowired
	private IMemberService memberService;
	@Autowired
	private IPointLogService pointLogService;

	@RequestMapping(value="/initManagerOrderList.action")
	public String initManagerOrderList(){
		return "order/orderlist_m";
	}
	
	@RequestMapping(value="/initOrderList.action")
	public String initOrderList(){
		return "order/orderlist";
	}
	
	@RequestMapping(value="/searchOrders.action")
	@ResponseBody
	public String searchOrders(ModelMap model,OrderQuery orderQuery,Pager pager,String orderBy){
		if(StringUtils.isBlank(orderBy)){
			orderBy="o.ordertime desc";
		}
		orderQuery.setOrderBy(orderBy);
		orderQuery.setPager(pager);
		int count=orderService.countByOrderQuery(orderQuery);
		List<OrderQuery> orderList=orderService.selectByOrderQuery(orderQuery);
		return DataGridJson(orderList, count);
	}
	
	@RequestMapping(value="/initOrderEdit.action")
	public String initOrderEdit(ModelMap model,OrderQuery order){
		model.put("order", orderService.selectByPrimaryKey(order.getId()));
		return "order/orderEdit";
	}
	
	@RequestMapping(value="/saveOrder.action")
	@ResponseBody
	public String saveOrder(Order order){
		Order o=orderService.selectByPrimaryKey(order.getId());
		if(o.getTotalprice()!=order.getTotalprice()){
			order.setPricemodified("1");
			
			OrderDetailExample orderDetailExample=new OrderDetailExample();
			orderDetailExample.createCriteria().andOrderidEqualTo(order.getId());
			List<OrderDetail> orderDetails=orderDetailService.selectByExample(orderDetailExample);
			double total=0.0;
			for(OrderDetail od:orderDetails){
				total+=od.getPrice();
			}
			for(OrderDetail od:orderDetails){
				od.setPrice(Double.valueOf(NumberUtil.toFixed(od.getPrice().doubleValue() / total * order.getTotalprice().doubleValue(), 2)));
				od.setTotalprice(NumberUtil.toFixed(od.getPrice()*od.getAmount(),2));
				orderDetailService.updateByPrimaryKeySelective(od);
			}
		}
		order.setModifyuser(super.getSessionInfo().getId());
		orderService.updateByPrimaryKeySelective(order);
		return "修改成功";
	}
	
	@RequestMapping(value="/initOrderDetail.action")
	public String initOrderDetail(ModelMap model,OrderQuery orderQuery){
		orderQuery=orderService.selectOrderQueryById(orderQuery.getId());
		model.put("order", orderQuery);
		
		OrderDetailQuery orderDetailQuery=new OrderDetailQuery();
		orderDetailQuery.setOrderid(orderQuery.getId());
		List<OrderDetailQuery> ods=orderDetailService.selectByOrderDetailQuery(orderDetailQuery);
		model.put("details", ods);
		
		return "order/orderDetail";
	}
	
	@RequestMapping(value="/sendOrder.action")
	@ResponseBody
	public String sendOrder(String ids){
		if(StringUtils.isBlank(ids)){
			return "发货失败!";
		}
		Order order=new Order();
		order.setIssend("1");
		order.setSendtime(new Date());
		OrderExample orderExample=new OrderExample();
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		orderExample.createCriteria().andIdIn(idlist);
		orderService.updateByExampleSelective(order, orderExample);
		
		String token=WeixinUtils.getToken();
		for(Long id:idlist){
			order=orderService.selectByPrimaryKey(id);
			Member member=memberService.selectByPrimaryKey(order.getMemberid());
			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			//给买家推送发货通知
			TemplateMsgUtil.sendTemplateMsg(token, TemplateMsgUtil.generateMgsJson(member.getOpenid(), TemplateMsgUtil.template_id_send, "http://weixin.karlay.cn/order/orderList?type=2", TemplateMsgUtil.generateSendSuccess("您好，您的订单已发货，订单编号:"+order.getCode(), "尺尚", sdf.format(new Date()), order.getReveivename(), order.getAddress(), "请你收到商品后尽快确认收货,感谢您对尺尚的支持!")));
		}
		return "发货成功!";
	}
	
	@RequestMapping(value="/cancelOrder.action")
	@ResponseBody
	public String cancelOrder(Long id){
		Order order=orderService.selectByPrimaryKey(id);
		Member member=memberService.selectByPrimaryKey(order.getMemberid());
		PointLogExample pointLogExample=new PointLogExample();
		pointLogExample.createCriteria().andMemberidEqualTo(member.getId()).andOrderidEqualTo(order.getId());
		List<PointLog> pointLogs=pointLogService.selectByExample(pointLogExample);
		orderService.deleteByPrimaryKey(id);
		OrderDetailExample orderDetailExample=new OrderDetailExample();
		orderDetailExample.createCriteria().andOrderidEqualTo(id);
		orderDetailService.deleteByExample(orderDetailExample);
		if(pointLogs!=null&&pointLogs.size()>0){
			member.setMemberpoint(member.getMemberpoint()+pointLogs.get(0).getPoint());
			memberService.updateByPrimaryKeySelective(member);
			
			pointLogService.deleteByExample(pointLogExample);
		}
		return "取消订单成功";
	}
	
	@RequestMapping(value="/disableOrder.action")
	@ResponseBody
	public String disableOrder(Long id){
		Order order=new Order();
		order.setId(id);
		order.setStatus("1");
		orderService.updateByPrimaryKeySelective(order);
		return "作废成功";
	}
	
}
