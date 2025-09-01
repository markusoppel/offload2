module gpuinitialize
        interface
                subroutine DPCPPinit() bind(C, name="DPCPPinit")
        end subroutine DPCPPinit
    end interface
end module gpuinitialize
