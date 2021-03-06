USE [u_smarek]
GO
/****** Object:  View [dbo].[IndividualOnSiteOrdersMoneyView]    Script Date: 25.03.2021 12:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IndividualOnSiteOrdersMoneyView]
AS
SELECT dbo.IndividualCustomers.CustomerID, dbo.IndividualReservations.OrderID, dbo.OrderDetails.Quantity * dbo.OrderDetails.UnitPrice AS OrderPrice
FROM   dbo.IndividualReservations INNER JOIN
          dbo.OnSiteOrders ON dbo.IndividualReservations.OrderID = dbo.OnSiteOrders.OrderID INNER JOIN
          dbo.OrderDetails ON dbo.OnSiteOrders.OrderID = dbo.OrderDetails.OrderID INNER JOIN
          dbo.IndividualCustomers ON dbo.IndividualReservations.CustomerID = dbo.IndividualCustomers.CustomerID
GROUP BY dbo.IndividualCustomers.CustomerID, dbo.IndividualReservations.OrderID, dbo.OrderDetails.Quantity * dbo.OrderDetails.UnitPrice
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[25] 2[27] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "IndividualReservations"
            Begin Extent = 
               Top = 87
               Left = 890
               Bottom = 361
               Right = 1216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OnSiteOrders"
            Begin Extent = 
               Top = 122
               Left = 442
               Bottom = 360
               Right = 737
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderDetails"
            Begin Extent = 
               Top = 24
               Left = 55
               Bottom = 314
               Right = 386
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IndividualCustomers"
            Begin Extent = 
               Top = 83
               Left = 1319
               Bottom = 348
               Right = 1714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IndividualOnSiteOrdersMoneyView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IndividualOnSiteOrdersMoneyView'
GO
